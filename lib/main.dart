import 'package:credbuddha/core/router/app_pages.dart';
import 'package:credbuddha/core/router/app_routes.dart';
import 'package:credbuddha/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:credbuddha/features/startup/screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'CredBuddha',
      theme: AppTheme.lightTheme,
      getPages: AppPages.routes,
      initialRoute: Routes.SPLASH,
    );
  }
}
