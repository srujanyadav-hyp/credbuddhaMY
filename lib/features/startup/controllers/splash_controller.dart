import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/router/app_routes.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _startTimer();
  }

  void _startTimer() async {
    await Future.delayed(const Duration(seconds: 4));

    // 2. Check Database (Shared Preferences)
    final prefs = await SharedPreferences.getInstance();
    final seenOnboarding = prefs.getBool('seen_onboarding') ?? false;
    final token = prefs.getString('auth_token');

    // 3. Decide where to go
    if (token != null) {
      print("User is logged in -> Go to Home");
      // Get.offNamed(Routes.HOME); // Uncomment when Home is ready
    } else if (seenOnboarding) {
      Get.offNamed(Routes.LOGIN);
    } else {
      Get.offNamed(Routes.ONBOARDING);
    }
  }
}
