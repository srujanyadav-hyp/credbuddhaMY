import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_dimensions.dart';
import '../controllers/onboarding_controller.dart';

class OnboardingScreen extends GetView<OnboardingController> {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            // ---  SKIP BUTTON (Top Right) ---
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: controller.completeOnboarding,
                child: Text(
                  "Skip",
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),

            // ---  SLIDER AREA ---
            Expanded(
              child: PageView.builder(
                controller: controller.pageController,
                onPageChanged: controller.updatePage,
                itemCount: controller.pages.length,
                itemBuilder: (context, index) {
                  final page = controller.pages[index];
                  return Padding(
                    padding: const EdgeInsets.all(AppDimens.p24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Image with simple animation
                        Image.asset(
                          page.image,
                          height: 250,
                        ).animate().scale(duration: 500.ms),

                        const SizedBox(height: AppDimens.p32),

                        // Title
                        Text(
                          page.title,
                          style: AppTextStyles.h2,
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: AppDimens.p16),

                        // Description
                        Text(
                          page.description,
                          style: AppTextStyles.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // ---  BOTTOM CONTROLS (Dots + Button) ---
            Padding(
              padding: const EdgeInsets.all(AppDimens.p24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // DOTS INDICATOR
                  Row(
                    children: List.generate(
                      controller.pages.length,
                      (index) => Obx(() {
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.only(right: 8),
                          height: 8,
                          width: controller.selectedPageIndex.value == index
                              ? 24
                              : 8, // Active dot is wider
                          decoration: BoxDecoration(
                            color: controller.selectedPageIndex.value == index
                                ? AppColors
                                      .primary // Active Green
                                : AppColors.border, // Inactive Grey
                            borderRadius: BorderRadius.circular(
                              AppDimens.rCircle,
                            ),
                          ),
                        );
                      }),
                    ),
                  ),

                  // NEXT / GET STARTED BUTTON
                  Obx(() {
                    final isLastPage =
                        controller.selectedPageIndex.value ==
                        controller.pages.length - 1;
                    return ElevatedButton(
                      onPressed: controller.forwardAction,
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(), // Round Button
                        padding: const EdgeInsets.all(AppDimens.p16),
                        backgroundColor: AppColors.primary,
                      ),
                      child: Icon(
                        isLastPage ? Icons.check : Icons.arrow_forward,
                        color: Colors.white,
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
