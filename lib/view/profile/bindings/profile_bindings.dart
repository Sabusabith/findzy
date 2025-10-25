import 'package:findzy/view/home/controller/home_controller.dart';
import 'package:findzy/view/profile/controller/profile_controller.dart';
import 'package:get/get.dart';

class ProfileBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}
