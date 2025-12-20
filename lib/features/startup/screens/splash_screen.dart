import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart'; // Ensure this is imported
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/loaders/app_loader.dart'; // Check this path matches your file
import '../controllers/splash_controller.dart';

class SplashScreen extends GetView<SplashController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Debug Print to prove screen is building
    print("BUILDING SPLASH SCREEN");

    return Scaffold(
      backgroundColor: AppColors.surface, // Ensure background isn't transparent
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Fixed typo
          children: [
            // --- IMAGE ANIMATION ---
            Image.asset(
                  'assets/images/welcome.png',
                  width: AppDimens
                      .splashLogo, // Ensure this isn't 0 in your dimens file!
                  height: 200, // Safety fallback height
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.error,
                      color: Colors.red,
                      size: 50,
                    ); // Shows if image is missing
                  },
                )
                .animate() // 1. Start Animation
                .slideY(
                  begin: -1.5, // Start from top
                  end: 0, // End at center
                  duration: 1500.ms,
                  curve: Curves.bounceOut,
                )
                .fadeIn(), // 2. Fade in
            Text(
                  "CredBuddha",
                  style: AppTextStyles.h1.copyWith(color: AppColors.primary),
                )
                .animate()
                .fade(duration: 800.ms, delay: 1000.ms) // Wait 1 sec, then show
                .slideY(begin: 0.5, end: 0),
            Column(
              children: [
                // --- TEXT ANIMATION ---
                const SizedBox(height: 20),

                // --- LOADER ANIMATION ---
                const SpinningArcLoader().animate().fade(
                  delay: 1500.ms,
                ), // Wait 1.5 sec, then show
              ],
            ),
          ],
        ),
      ),
    );
  }
}
