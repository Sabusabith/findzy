import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeController extends GetxController {
  var selectedIndex = 0.obs;
  var currentAddress = "Locating...".obs;
  var currentPosition = Rxn<Position>();
  var maxDistance = 5.0.obs; // default 5 km

  @override
  void onInit() {
    super.onInit();
    _determinePosition();
  }

  void changeTab(int index) {
    selectedIndex.value = index;
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar(
        "Location Disabled",
        "Please enable GPS/location services.",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      await Geolocator.openLocationSettings();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar(
          "Permission Denied",
          "Location access is required.",
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Get.snackbar(
        "Permission Denied Permanently",
        "Enable location permission from settings.",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      await Geolocator.openAppSettings();
      return;
    }

    // Permission granted → get position
    currentPosition.value = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // Get human-readable address
    _getAddressFromLatLng(
      currentPosition.value!.latitude,
      currentPosition.value!.longitude,
    );
  }

  Future<void> _getAddressFromLatLng(double lat, double lon) async {
    try {
      final url = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse?format=json&lat=$lat&lon=$lon',
      );

      final response = await http.get(url, headers: {'User-Agent': 'app/1.0'});

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final fullAddress = data['display_name'] ?? "Unknown location";

        // Split safely and convert each part to String
        final parts = <String>[];
        for (var part in fullAddress.split(',')) {
          parts.add(part.toString().trim());
        }

        if (parts.length >= 2) {
          currentAddress.value = "${parts[0]}, ${parts[1]}";
        } else if (parts.isNotEmpty) {
          currentAddress.value = parts[0];
        } else {
          currentAddress.value = fullAddress;
        }
      } else {
        currentAddress.value = "Unable to fetch location";
      }
    } catch (e) {
      currentAddress.value = "Error fetching location";
      print("Reverse geocoding error: $e");
    }
  }
}
