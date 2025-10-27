import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';

class OnboardingController extends GetxController {
  var currentPage = 0.obs;
  PageController pageController = PageController();

  void nextPage() {
    if (currentPage.value < 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      Get.offAllNamed('/home'); // Navigate to Home
    }
  }

  void onPageChanged(int index) {
    currentPage.value = index;
  }

  Future<void> requestLocationPermission(BuildContext context) async {
    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      // ✅ Permission granted → go to home
      Get.offAllNamed('/home');
    } else if (permission == LocationPermission.denied) {
      // 🚫 Denied once
      // Get.snackbar(
      //   "Permission Denied",
      //   "You can still explore manually, but nearby features won't work properly.",
      //   backgroundColor: Colors.orangeAccent,
      //   colorText: Colors.white,
      // );
      Get.offAllNamed('/home'); // Optionally still navigate
    } else if (permission == LocationPermission.deniedForever) {
      // ❌ Denied forever
      // Get.snackbar(
      //   "Permission Blocked",
      //   "Please enable location manually in settings.",
      //   backgroundColor: Colors.redAccent,
      //   colorText: Colors.white,
      // );
    }
  }
}
