import 'package:findzy/core/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class SplashController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> scaleAnim;
  late Animation<double> fadeAnim;

  @override
  void onInit() {
    super.onInit();

    // AnimationController for pulsing text & glow
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    scaleAnim = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeInOut),
    );

    fadeAnim = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeInOut),
    );

    // Navigate after 3 seconds
    Future.delayed(const Duration(seconds: 2), () {
      Get.offAllNamed(Routes.ONBOARDING);
    });
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }
}
