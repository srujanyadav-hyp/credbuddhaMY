import 'package:get/get.dart';

import '../controllers/splash_controller.dart';

class SplashBinder extends Bindings {
  @override
  void dependencies() {
    Get.put(SplashController());
  }
}
