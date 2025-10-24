import 'package:findzy/view/home/controller/home_controller.dart';
import 'package:findzy/view/splash/controller/splash_controller.dart';
import 'package:get/get.dart';

class SplashBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashController>(() => SplashController());
  }
}
