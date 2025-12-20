import '../controllers/onboarding_controller.dart';
import 'package:get/get.dart';

class OnboardingBinder extends Bindings {
  @override
  void dependencies() {
    print(" DEBUG: OnboardingBinder is RUNNING!");
    Get.put(OnboardingController());
    print("DEBUG: OnboardingController has been put!");
  }
}
