import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For TextInputFormatter
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/utils/formatter.dart';
import '../controllers/login_controller.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      // --- SAFE AREA: Don't hide behind status bars --- //
      body: SafeArea(
        //--- SCROLL VIEW: Essential for when keyboard opens!--- //
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimens.p24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppDimens.p48),

              // --- HEADER ---//
              Text(
                "Welcome Back!",
                style: AppTextStyles.h1,
              ).animate().fadeIn().slideX(),
              const SizedBox(height: AppDimens.p8),
              Text(
                "Enter your mobile number to continue",
                style: AppTextStyles.bodyMedium.copyWith(color: Colors.grey),
              ).animate().fadeIn(delay: 200.ms),

              const SizedBox(height: AppDimens.p48),

              // --- INPUT FIELD ---//
              Text("Mobile Number", style: AppTextStyles.bodyMedium),
              const SizedBox(height: AppDimens.p8),

              // TextField(
              //   controller: controller.phoneController,
              //   keyboardType: TextInputType.phone,
              //   maxLength: 10, // Hard limit
              //   style: AppTextStyles.h3,

              //   // UX: Only allow numbers
              //   inputFormatters: [FilteringTextInputFormatter.digitsOnly],

              //   decoration: InputDecoration(
              //     hintText: "Enter 10 digit number",
              //     prefixIcon: const Icon(
              //       Icons.phone_android,
              //       color: AppColors.primary,
              //     ),
              //     prefixText: "+91 ", // India Code
              //     counterText: "", // Hide the 0/10 counter
              //     // Styles
              //     filled: true,
              //     fillColor: AppColors.background,
              //     border: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(AppDimens.r12),
              //       borderSide: BorderSide.none,
              //     ),
              //     focusedBorder: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(AppDimens.r12),
              //       borderSide: const BorderSide(
              //         color: AppColors.primary,
              //         width: 2,
              //       ),
              //     ),
              //   ),
              // ),

              // --- correction of formating the mobile number entering --- //
              TextField(
                controller: controller.phoneController,
                keyboardType: TextInputType.phone, // Shows number pad
                maxLength: 10,

                inputFormatters: [
                  // 1. Only allow digits (standard check)
                  FilteringTextInputFormatter.digitsOnly,

                  // 2. BLOCK 0-5 as the first character (Our custom rule)
                  IndianMobileFormatter(),
                ],

                decoration: InputDecoration(
                  hintText: "Enter 10 digit number",
                  prefixIcon: const Icon(
                    Icons.phone_android,
                    color: AppColors.primary,
                  ),
                  prefixText: "+91 ", // India Code
                  counterText: "", // Hide the 0/10 counter
                  // Styles
                  filled: true,
                  fillColor: AppColors.background,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDimens.r12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDimens.r12),
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 2,
                    ),
                  ),
                ),

                // ... rest of your styling
              ),

              // --- ERROR MESSAGE (Reactive) ---//
              Obx(
                () => controller.errorMessage.value.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          controller.errorMessage.value,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),

              const SizedBox(height: AppDimens.p32),

              // --- ACTION BUTTON ---
              SizedBox(
                width: double.infinity,
                height: AppDimens.buttonHeight,
                child: Obx(() {
                  // 3. STATE HANDLING: Loading vs Active vs Disabled
                  if (controller.isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    );
                  }

                  return ElevatedButton(
                    onPressed: controller.isButtonEnabled.value
                        ? controller.sendOtp
                        : null, // Null disables the button automatically

                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      disabledBackgroundColor:
                          Colors.grey.shade300, // UX: Grey out if invalid
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppDimens.r12),
                      ),
                    ),
                    child: const Text(
                      "Get OTP",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }),
              ),

              const SizedBox(height: AppDimens.p24),

              // --- TRUST BADGE (Psychology) ---
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.lock_outline,
                      size: 14,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "Your data is 100% secure with CredBuddha",
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
