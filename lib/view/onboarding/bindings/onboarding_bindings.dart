import 'package:findzy/view/home/controller/home_controller.dart';
import 'package:findzy/view/onboarding/controller/onboarding_controller.dart';
import 'package:get/get.dart';

class OnboardingBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OnboardingController>(() => OnboardingController());
  }
}
