import 'package:findzy/view/home/controller/home_controller.dart';
import 'package:findzy/view/search/controller/search_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SearchControllerX>(() => SearchControllerX());
  }
}
