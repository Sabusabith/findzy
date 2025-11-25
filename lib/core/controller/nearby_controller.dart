import 'dart:async';
import 'dart:convert';
import 'package:findzy/view/home/widgets/webview.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NearbyPlaceController extends GetxController {
  final String placeType;
  final String osmKey;
  final String osmValue;
  double radiusInMeters;

  var places = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;

  NearbyPlaceController({
    required this.placeType,
    required this.osmKey,
    required this.osmValue,
    required this.radiusInMeters,
  });

  @override
  void onInit() {
    super.onInit();
    fetchNearbyPlaces();
  }

  void savePlaceToHistory(Map<String, dynamic> place) {
    final Box historyBox = Hive.box('search_history');

    final newItem = {
      "display_name": place['name'],
      "lat": place['lat'],
      "lon": place['lon'],
      "address": place['address'],
    };

    // Load existing history
    List<Map<String, dynamic>> history = List<Map<String, dynamic>>.from(
      historyBox.get('items', defaultValue: <Map<String, dynamic>>[]),
    );

    // Remove duplicate if exists
    history.removeWhere((e) => e['display_name'] == newItem['display_name']);

    // Insert new at top
    history.insert(0, newItem);

    // Keep max 10 items
    if (history.length > 10) history.removeLast();

    // Save back to Hive
    historyBox.put('items', history);

    print("✅ Saved ${newItem['display_name']} to search history");
  }

  Future<void> fetchNearbyPlaces() async {
    isLoading.value = true;

    try {
      Position position = await _determinePosition();
      double userLat = position.latitude;
      double userLon = position.longitude;

      final box = Hive.box('placesCache');
      // include radius in cache key
      final cacheKey = "$placeType-${radiusInMeters.toInt()}";

      final cachedData = box.get(cacheKey);
      if (cachedData != null) {
        final Map<String, dynamic> cachedMap = Map<String, dynamic>.from(
          cachedData,
        );
        final lastLat = cachedMap['lat'] as double;
        final lastLon = cachedMap['lon'] as double;
        final distanceMoved = Geolocator.distanceBetween(
          userLat,
          userLon,
          lastLat,
          lastLon,
        );
        final cachedTime = DateTime.parse(cachedMap['timestamp']);
        final age = DateTime.now().difference(cachedTime).inHours;

        if (distanceMoved < 1000 && age < 24) {
          places.value = List<Map<String, dynamic>>.from(
            cachedMap['data'].map((e) => Map<String, dynamic>.from(e)),
          );
          print(
            "✅ Loaded $placeType from cache (radius: ${radiusInMeters / 1000} km)",
          );
          isLoading.value = false;
          return;
        } else {
          await box.delete(cacheKey);
          print("🗑️ Old cache cleared for radius ${radiusInMeters / 1000} km");
        }
      }

      final url = Uri.parse(
        'https://overpass-api.de/api/interpreter?data=[out:json];node["$osmKey"="$osmValue"](around:$radiusInMeters,$userLat,$userLon);out;',
      );
      final response = await http.get(url).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List elements = data['elements'];

        if (elements.isEmpty) {
          _showInfoSnackbar(
            title: "No $placeType Found",
            message:
                "There are no $placeType within ${radiusInMeters / 1000} km.",
          );
        }

        final fetchedPlaces = await Future.wait(
          elements.map((e) async {
            final lat = e['lat'] as double;
            final lon = e['lon'] as double;
            final tags = e['tags'] ?? {};

            final distanceMeters = Geolocator.distanceBetween(
              userLat,
              userLon,
              lat,
              lon,
            );
            final distanceKm = distanceMeters / 1000;

            String address = '';
            if (tags['addr:full'] != null) {
              address = tags['addr:full'];
            } else if (tags['addr:housenumber'] != null &&
                tags['addr:street'] != null) {
              address =
                  '${tags['addr:housenumber']} ${tags['addr:street']}, ${tags['addr:city'] ?? ''}';
            } else {
              address =
                  tags['addr:street'] ??
                  tags['addr:place'] ??
                  tags['addr:city'] ??
                  '';
            }

            if (address.trim().isEmpty) {
              address = await _getAddressFromLatLon(lat, lon);
            }

            bool isOpen = false;
            final rawOH = tags['opening_hours'];
            if (rawOH != null) {
              isOpen = _checkIfOpen(rawOH);
            } else {
              final nowHour = DateTime.now().hour;
              isOpen = nowHour >= 8 && nowHour < 20;
            }

            return {
              'name': tags['name'] ?? 'Unnamed $placeType',
              'lat': lat,
              'lon': lon,
              'address': address,
              'distance': distanceKm.toStringAsFixed(2),
              'isOpen': isOpen,
            };
          }).toList(),
        );

        fetchedPlaces.sort(
          (a, b) => double.parse(
            a['distance'],
          ).compareTo(double.parse(b['distance'])),
        );
        places.value = fetchedPlaces;

        await box.put(cacheKey, {
          'lat': userLat,
          'lon': userLon,
          'timestamp': DateTime.now().toIso8601String(),
          'data': fetchedPlaces,
        });

        print("💾 Cached $placeType successfully");
      } else {
        _showErrorSnackbar(title: "Server Error", message: "Try again later.");
      }
    } on TimeoutException {
      _showErrorSnackbar(title: "Timeout", message: "Server took too long.");
    } catch (e) {
      _showErrorSnackbar(title: "Error", message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  bool _checkIfOpen(String openingHours) {
    final oh = openingHours.toLowerCase().replaceAll(' ', '');
    final now = DateTime.now();
    if (oh.contains('24/7')) return true;

    try {
      final weekdays = {
        'mo': 1,
        'tu': 2,
        'we': 3,
        'th': 4,
        'fr': 5,
        'sa': 6,
        'su': 7,
      };
      final parts = oh.split(';');
      for (var part in parts) {
        final dayMatch = RegExp(
          r'(mo|tu|we|th|fr|sa|su)(?:-(mo|tu|we|th|fr|sa|su))?',
        ).firstMatch(part);
        final timeMatch = RegExp(
          r'(\d{2}):(\d{2})-(\d{2}):(\d{2})',
        ).firstMatch(part);
        if (dayMatch != null && timeMatch != null) {
          final startDay = weekdays[dayMatch.group(1)!]!;
          final endDay = dayMatch.group(2) != null
              ? weekdays[dayMatch.group(2)!]!
              : startDay;
          if (now.weekday >= startDay && now.weekday <= endDay) {
            final start = TimeOfDay(
              hour: int.parse(timeMatch.group(1)!),
              minute: int.parse(timeMatch.group(2)!),
            );
            final end = TimeOfDay(
              hour: int.parse(timeMatch.group(3)!),
              minute: int.parse(timeMatch.group(4)!),
            );
            final nowTime = TimeOfDay(hour: now.hour, minute: now.minute);
            if (_isTimeBetween(nowTime, start, end)) return true;
          }
        }
      }
      final nowHour = now.hour;
      return nowHour >= 8 && nowHour < 20;
    } catch (_) {
      final nowHour = now.hour;
      return nowHour >= 8 && nowHour < 20;
    }
  }

  bool _isTimeBetween(TimeOfDay now, TimeOfDay start, TimeOfDay end) {
    final nowMinutes = now.hour * 60 + now.minute;
    final startMinutes = start.hour * 60 + start.minute;
    final endMinutes = end.hour * 60 + end.minute;
    return nowMinutes >= startMinutes && nowMinutes <= endMinutes;
  }

  Future<String> _getAddressFromLatLon(double lat, double lon) async {
    try {
      final url = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?format=json&lat=$lat&lon=$lon',
      );
      final response = await http.get(url, headers: {'User-Agent': 'app/1.0'});
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['display_name'] ?? 'Address not available';
      }
    } catch (e) {
      print("❌ Reverse geocoding failed: $e");
    }
    return 'Address not available';
  }

  Future<void> openInMaps(double lat, double lon) async {
    final Uri googleNavUrl = Uri.parse('google.navigation:q=$lat,$lon&mode=d');
    final Uri fallbackUrl = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=$lat,$lon&travelmode=driving',
    );

    try {
      if (await canLaunchUrl(googleNavUrl)) {
        await launchUrl(googleNavUrl, mode: LaunchMode.externalApplication);
      } else if (await canLaunchUrl(fallbackUrl)) {
        await launchUrl(fallbackUrl, mode: LaunchMode.externalApplication);
      } else {
        Get.snackbar(
          "Maps Not Available",
          "Could not open Maps",
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Navigation Error",
        "Unable to open directions",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) throw Exception('Location services are disabled.');
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied)
      permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever)
      throw Exception('Location permissions are denied.');
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  void openWebSearch(
    String name,
    String address,
    Color startColor,
    Color endColor,
  ) {
    final query = Uri.encodeComponent("$name $address");
    final url = "https://www.google.com/search?q=$query";

    Get.to(
      () => WebViewPage(
        title: name,
        url: url,
        startColor: startColor,
        endColor: endColor,
      ),
    );
  }

  void _showErrorSnackbar({required String title, required String message}) {
    Get.snackbar(
      title,
      message,
      backgroundColor: Colors.grey[850],
      colorText: Colors.redAccent,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      borderRadius: 12,
      animationDuration: const Duration(milliseconds: 400),
      duration: const Duration(seconds: 3),
      icon: const Icon(Icons.error_outline, color: Colors.redAccent),
      overlayBlur: 2,
      overlayColor: Colors.black38,
    );
  }

  void _showInfoSnackbar({required String title, required String message}) {
    Get.snackbar(
      title,
      message,
      backgroundColor: Colors.grey[850],
      colorText: Colors.lightBlueAccent,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      borderRadius: 12,
      animationDuration: const Duration(milliseconds: 400),
      duration: const Duration(seconds: 3),
      icon: const Icon(Icons.info_outline, color: Colors.lightBlueAccent),
      overlayBlur: 2,
      overlayColor: Colors.black38,
    );
  }
}
