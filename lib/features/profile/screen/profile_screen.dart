import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/profile_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/utils/formatter.dart';
import "../../../shared/widgets/custom_text_field.dart";
import '../../../shared/widgets/custom_radio_tile.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(title: const Text("Complete Your Profile")),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Theme(
          data: theme.copyWith(
            colorScheme: theme.colorScheme.copyWith(
              primary: AppColors.primary,
              secondary: AppColors.secondary,
            ),
          ),
          child: Stepper(
            type: StepperType.vertical,
            currentStep: controller.currentStep.value,

            // Custom Button Builder
            controlsBuilder: (context, details) {
              return Padding(
                padding: const EdgeInsets.only(top: AppDimens.p20),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: details.onStepContinue,
                        // Update: Check for Step 3 (Identity) for "Submit"
                        child: Text(
                          controller.currentStep.value == 3 ? "Submit" : "Next",
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

            onStepContinue: () => controller.goNext(),
            onStepCancel: () {
              if (controller.currentStep.value > 0) {
                controller.currentStep.value--;
              }
            },

            steps: [
              // --- STEP 1: BASIC DETAILS (Index 0) ---
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
                      onSubmitted: (_) => controller.goNext(),
                    ),
                    const SizedBox(height: AppDimens.p16),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Gender",
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Obx(
                      () => Row(
                        children: [
                          CustomRadioTile(
                            title: "Male",
                            value: "Male",
                            groupValue: controller.selectedGender.value,
                            onChanged: (val) =>
                                controller.selectedGender.value = val!,
                          ),
                          const SizedBox(width: 8),
                          CustomRadioTile(
                            title: "Female",
                            value: "Female",
                            groupValue: controller.selectedGender.value,
                            onChanged: (val) =>
                                controller.selectedGender.value = val!,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                isActive: controller.currentStep.value >= 0,
                state: controller.currentStep.value > 0
                    ? StepState.complete
                    : StepState.indexed,
              ),

              // --- STEP 2: ADDRESS (Index 1) ---
              Step(
                title: Text("Address", style: theme.textTheme.titleLarge),
                content: Column(
                  children: [
                    const SizedBox(height: AppDimens.p8),

                    // Location Button
                    Center(
                      child: TextButton.icon(
                        onPressed: () => controller.fetchCurrentAddress(),
                        icon: const Icon(
                          Icons.my_location,
                          color: AppColors.primary,
                        ),
                        label: const Text(
                          "Use Current Location",
                          style: TextStyle(color: AppColors.primary),
                        ),
                        style: TextButton.styleFrom(
                          backgroundColor: AppColors.primary.withOpacity(0.1),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Fields
                    CustomTextField(
                      label: "Full Address",
                      controller: controller.addressController,
                      icon: Icons.home,
                    ),
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            label: "City",
                            controller: controller.cityController,
                            icon: Icons.location_city,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: CustomTextField(
                            label: "Pincode",
                            controller: controller.pincodeController,
                            icon: Icons.pin_drop,
                            isNumber: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: "State",
                      controller: controller.stateController,
                      icon: Icons.map,
                      onSubmitted: (_) => controller.goNext(),
                    ),
                  ],
                ),
                isActive: controller.currentStep.value >= 1,
                state: controller.currentStep.value > 1
                    ? StepState.complete
                    : StepState.indexed,
              ),

              // --- STEP 3: EMPLOYMENT (Index 2) ---
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

                    Obx(
                      () => CustomTextField(
                        label: controller.selectedEmployment.value == "Student"
                            ? "Monthly Pocket Money / Allowance"
                            : "Monthly Income",
                        controller: controller.salaryController,
                        icon: Icons.currency_rupee,
                        keyboardType: TextInputType.number,
                        onSubmitted: (_) => controller.goNext(),
                      ),
                    ),
                  ],
                ),
                isActive: controller.currentStep.value >= 2,
                state: controller.currentStep.value > 2
                    ? StepState.complete
                    : StepState.indexed,
              ),

              // --- STEP 4: IDENTITY (Index 3) ---
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
                      maxLength: 10,
                      inputFormatters: [PanCardFormatter()],
                      onSubmitted: (_) => controller.submitProfile(),
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
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
                isActive: controller.currentStep.value >= 3,
              ),
            ],
          ),
        );
      }),
    );
  }
}
