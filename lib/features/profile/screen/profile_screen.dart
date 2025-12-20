import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/profile_controller.dart';
// IMPORT YOUR THEME FILES
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
// import '../../../core/theme/app_typography.dart'; // Accessed via Theme.of(context)

// Improt your custom Widgets
import "../../../shared/widgets/custom_text_field.dart";
import '../../../shared/widgets/custom_radio_tile.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());
    final theme = Theme.of(context); // Access global theme

    return Scaffold(
      // Use theme background (AppColors.background)
      backgroundColor: theme.scaffoldBackgroundColor,

      appBar: AppBar(
        title: const Text("Complete Your Profile"),
        // The rest is handled by AppTheme.appBarTheme automatically!
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Theme(
          // We override the ColorScheme just for the Stepper to match our AppColors
          data: theme.copyWith(
            colorScheme: theme.colorScheme.copyWith(
              primary: AppColors.primary,
              secondary: AppColors.secondary,
            ),
          ),
          child: Stepper(
            type: StepperType.vertical,
            currentStep: controller.currentStep.value,

            // Standard App Padding
            controlsBuilder: (context, details) {
              return Padding(
                padding: const EdgeInsets.only(top: AppDimens.p20),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: details.onStepContinue,
                        // Button style comes from AppTheme, but we can override text
                        child: Text(
                          controller.currentStep.value == 2 ? "Submit" : "Next",
                        ),
                      ),
                    ),
                    if (controller.currentStep.value > 0) ...[
                      const SizedBox(width: AppDimens.p12),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: details.onStepCancel,
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              vertical: AppDimens.p16,
                            ),
                            side: const BorderSide(color: AppColors.primary),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppDimens.r8),
                            ),
                          ),
                          child: Text(
                            "Back",
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },

            onStepContinue: () {
              if (controller.currentStep.value < 2) {
                controller.currentStep.value++;
              } else {
                controller.submitProfile();
              }
            },
            onStepCancel: () {
              if (controller.currentStep.value > 0) {
                controller.currentStep.value--;
              }
            },

            steps: [
              // --- STEP 1: BASIC DETAILS ---
              Step(
                title: Text("Basic Details", style: theme.textTheme.titleLarge),
                content: Column(
                  children: [
                    const SizedBox(height: AppDimens.p8),
                    CustomTextField(
                      label: "Full Name (As per PAN)",
                      controller: controller.nameController,
                      icon: Icons.person,
                    ),
                    const SizedBox(height: AppDimens.p16),
                    CustomTextField(
                      label: "Email Address",
                      controller: controller.emailController,
                      icon: Icons.email,
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ],
                ),
                isActive: controller.currentStep.value >= 0,
                state: controller.currentStep.value > 0
                    ? StepState.complete
                    : StepState.indexed,
              ),

              // ----Step 2: Employment deatils ----
              Step(
                title: Text("Employment", style: theme.textTheme.titleLarge),
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppDimens.p8),
                    Text(
                      "Employment Type",
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AppDimens.p8),

                    // UPDATED: Using Wrap to fit multiple options
                    Obx(
                      () => Column(
                        children: [
                          Row(
                            children: [
                              CustomRadioTile(
                                title: "Salaried",
                                value: "Salaried",
                                groupValue: controller.selectedEmployment.value,
                                onChanged: (val) =>
                                    controller.selectedEmployment.value = val!,
                              ),
                              const SizedBox(width: 10),
                              CustomRadioTile(
                                title: "Self-Employed",
                                value: "Self-Employed",
                                groupValue: controller.selectedEmployment.value,
                                onChanged: (val) =>
                                    controller.selectedEmployment.value = val!,
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              CustomRadioTile(
                                title: "Student",
                                value: "Student",
                                groupValue: controller.selectedEmployment.value,
                                onChanged: (val) =>
                                    controller.selectedEmployment.value = val!,
                              ),
                              const SizedBox(width: 10),
                              CustomRadioTile(
                                title: "Other",
                                value: "Other",
                                groupValue: controller.selectedEmployment.value,
                                onChanged: (val) =>
                                    controller.selectedEmployment.value = val!,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: AppDimens.p16),

                    // LOGIC: Change label based on selection
                    Obx(
                      () => CustomTextField(
                        // If Student, ask "Pocket Money" instead of "Salary"
                        label: controller.selectedEmployment.value == "Student"
                            ? "Monthly Pocket Money / Allowance"
                            : "Monthly Income",
                        controller: controller.salaryController,
                        icon: Icons.currency_rupee,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                isActive: controller.currentStep.value >= 1,
                state: controller.currentStep.value > 1
                    ? StepState.complete
                    : StepState.indexed,
              ),

              // --- STEP 3: IDENTITY ---
              Step(
                title: Text("Identity", style: theme.textTheme.titleLarge),
                content: Column(
                  children: [
                    const SizedBox(height: AppDimens.p8),
                    CustomTextField(
                      label: "PAN Number",
                      controller: controller.panController,
                      icon: Icons.badge,
                      textCapitalization: TextCapitalization.characters,
                    ),
                    const SizedBox(height: AppDimens.p12),
                    Row(
                      children: [
                        const Icon(
                          Icons.lock,
                          size: AppDimens.iconSmall,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: AppDimens.p4),
                        Text(
                          "Your data is 100% secure with 256-bit encryption.",
                          style:
                              theme.textTheme.bodySmall, // Uses caption style
                        ),
                      ],
                    ),
                  ],
                ),
                isActive: controller.currentStep.value >= 2,
              ),
            ],
          ),
        );
      }),
    );
  }
}
