import 'package:findzy/core/routes/app_pages.dart';
import 'package:findzy/core/utils/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

void main(List<String> args) {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.SPLASH,
          theme: AppTheme.hueTheme,

      getPages: AppPages.routes,

    );
  }
}