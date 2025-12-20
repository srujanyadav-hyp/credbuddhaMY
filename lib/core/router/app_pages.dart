import 'package:credbuddha/features/startup/bindings/onboarding_binder.dart';
import 'package:get/get.dart';

// Import Screens
import '../../features/startup/screens/splash_screen.dart';
import '../../features/startup/screens/onboarding_screen.dart';
import '../../features/auth/screens/login_screen.dart';
// import '../../features/auth/screens/otp_screen.dart';

// Import Bindings
import '../../features/startup/bindings/splash_binder.dart';
import '../../features/auth/bindings/login_binder.dart';

// Import Route Names
import 'app_routes.dart';

class AppPages {
  // The first screen to show when app starts
  static const INITIAL = Routes.SPLASH;

  static final routes = [
    // 1. Splash Screen
    GetPage(
      name: Routes.SPLASH,
      page: () => const SplashScreen(),
      binding: SplashBinder(), // Connects SplashController
      transition: Transition.fadeIn, // Nice fade effect
    ),

    // 2. Onboarding Screen
    GetPage(
      name: Routes.ONBOARDING,
      page: () => const OnboardingScreen(),
      // No binding needed if it doesn't have a complex controller
      binding: OnboardingBinder(),
      transition: Transition.rightToLeft,
    ),

    //3. Login Screen
    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginScreen(),
      binding: AuthBinding(), // Connects LoginController
      transition: Transition.rightToLeft,
    ),

    // // 4. OTP Screen
    // GetPage(
    //   name: Routes.OTP,
    //   page: () => const OtpScreen(),
    //   binding: AuthBinding(), // Reuses logic from Login
    //   transition: Transition.cupertino, // Smooth iOS style slide
    // ),
  ];
}
