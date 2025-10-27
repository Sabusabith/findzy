import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeController extends GetxController {
  var selectedIndex = 0.obs;
  var currentAddress = "Locating...".obs;
  var currentPosition = Rxn<Position>();
  var maxDistance = 5.0.obs;

  @override
  void onInit() {
    super.onInit();
    checkPermissionAndLocation();
  }

  void changeTab(int index) {
    selectedIndex.value = index;
  }

  /// Checks if location permission is available
  Future<void> checkPermissionAndLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      Future.delayed(const Duration(milliseconds: 800), () {
        _showPermissionDialog();
      });
      currentAddress.value = "Location permission denied";
      return;
    }

    _determinePosition();
  }

  Future<void> _determinePosition() async {
    try {
      currentAddress.value = "Updating...";
      currentPosition.value = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      _getAddressFromLatLng(
        currentPosition.value!.latitude,
        currentPosition.value!.longitude,
      );
    } catch (e) {
      currentAddress.value = "Location unavailable";
      print("Error getting position: $e");
    }
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
        final parts = fullAddress.split(',').map((e) => e.trim()).toList();

        currentAddress.value = parts.length >= 2
            ? "${parts[0]}, ${parts[1]}"
            : fullAddress;
      } else {
        currentAddress.value = "Unable to fetch location";
      }
    } catch (e) {
      currentAddress.value = "Error fetching location";
      print("Reverse geocoding error: $e");
    }
  }

  Future<bool> checkAndRequestLocation(BuildContext context) async {
    bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
    LocationPermission permission = await Geolocator.checkPermission();

    if (!isLocationEnabled) {
      // 🔴 If location service is off
      Get.dialog(
        AlertDialog(
          backgroundColor: const Color(0xFF1E1F2E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            "Location Disabled",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          content: const Text(
            "Please enable location services to find nearby places.",
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () async {
                Get.back();
                await Geolocator.openLocationSettings();
              },
              child: const Text(
                "Open Settings",
                style: TextStyle(color: Colors.greenAccent),
              ),
            ),
          ],
        ),
      );
      return false;
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      // 🔴 Permission denied
      _showPermissionDialog();
      return false;
    }

    // ✅ Everything OK
    return true;
  }

  /// Shows dialog if permission denied
  void _showPermissionDialog() {
    Get.dialog(
      AlertDialog(
        backgroundColor: const Color(0xFF1E1F2E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          "Location Access Needed",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          "To find nearby petrol pumps and hospitals, please enable location access from settings.",
          style: TextStyle(color: Colors.white70, fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () async {
              await Geolocator.openAppSettings();
              Get.back();
            },
            child: const Text(
              "Grant Permission",
              style: TextStyle(color: Colors.greenAccent),
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  /// Manual refresh button handler
  Future<void> refreshLocation() async {
    currentAddress.value = "Updating...";
    await checkPermissionAndLocation();
  }
}
