import 'package:findzy/view/onboarding/controller/onboarding_controller.dart';
import 'package:findzy/view/onboarding/views/onboarding_one.dart';
import 'package:findzy/view/onboarding/views/onboarding_two.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnboardingController());

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2C),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: controller.pageController,
                onPageChanged: controller.onPageChanged,
                children: [OnboardPage1(), OnboardPage2()],
              ),
            ),
            const SizedBox(height: 20),
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(2, (index) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    width: controller.currentPage.value == index ? 20 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: controller.currentPage.value == index
                          ? Colors.blueAccent
                          : Colors.white24,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 20),
            Obx(
              () => Padding(
                padding: const EdgeInsets.all(20),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 50,
                      vertical: 8,
                    ),
                  ),
                  onPressed: () {
                    if (controller.currentPage.value == 1) {
                      controller.requestLocationPermission(context);
                      Get.offAllNamed('/home');
                    } else {
                      controller.nextPage();
                    }
                  },
                  child: Text(
                    controller.currentPage.value == 1 ? "Get Started" : "Next",
                    style: GoogleFonts.nunito(fontSize: 14),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
