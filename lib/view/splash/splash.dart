import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import 'controller/splash_controller.dart';

class Splash extends StatelessWidget {
  Splash({super.key});

  final SplashController controller = Get.find<SplashController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF100B20), Color(0xFF1A0F36)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // Animated Glow Circle
          AnimatedBuilder(
            animation: controller.animationController,
            builder: (_, child) {
              return Transform.scale(
                scale: controller.scaleAnim.value,
                child: Opacity(
                  opacity: controller.fadeAnim.value,
                  child: Container(
                    width: 250,
                    height: 250,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          kPrimaryColor.withOpacity(0.35),
                          Colors.transparent,
                        ],
                        radius: 0.6,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: kPrimaryColor.withOpacity(0.5),
                          blurRadius: 50,
                          spreadRadius: 20,
                        ),
                        BoxShadow(
                          color: kSecondaryColor.withOpacity(0.2),
                          blurRadius: 80,
                          spreadRadius: 40,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),

          // Hue-style “Findzy” Text
          AnimatedBuilder(
            animation: controller.animationController,
            builder: (_, child) {
              return Transform.scale(
                scale: controller.scaleAnim.value,
                child: Opacity(
                  opacity: controller.fadeAnim.value,
                  child: Text(
                    "Findzy",
                    style: GoogleFonts.nunito(
                      fontSize: 52,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: 1.5,
                      shadows: [
                        Shadow(
                          color: kPrimaryColor.withOpacity(0.8),
                          blurRadius: 30,
                        ),
                        Shadow(
                          color: kSecondaryColor.withOpacity(0.5),
                          blurRadius: 50,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
