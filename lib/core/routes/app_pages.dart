import 'package:findzy/view/home/bindings/home_bindigs.dart';
import 'package:findzy/view/home/home.dart';
import 'package:findzy/view/onboarding/bindings/onboarding_bindings.dart';
import 'package:findzy/view/onboarding/views/onboarding.dart';
import 'package:findzy/view/profile/bindings/profile_bindings.dart';
import 'package:findzy/view/profile/profile.dart';
import 'package:findzy/view/splash/bindings/splash_bindings.dart';
import 'package:findzy/view/splash/splash.dart';
import 'package:get/get.dart';

part 'app_routs.dart';

class AppPages {
  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: Routes.SPLASH,
      page: () => Splash(),
      binding: SplashBindings(),
    ),

    GetPage(
      name: Routes.HOME,
      page: () => Home(),
      binding: HomeBinding(),
      transition: Transition.cupertino, // smooth professional transition
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: Routes.PROFILE,
      page: () => Profile(),
      binding: ProfileBindings(),
      transition: Transition.downToUp, // smooth professional transition
      transitionDuration: const Duration(milliseconds: 200),
    ),
    GetPage(
      name: Routes.ONBOARDING,
      page: () => OnboardingScreen(),
      binding: OnboardingBindings(),
      transition: Transition.cupertino, // smooth professional transition
      transitionDuration: const Duration(milliseconds: 400),
    ),
  ];
}
