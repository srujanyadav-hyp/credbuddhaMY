import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/profile_repository.dart';
import '../../../core/router/app_routes.dart';

class ProfileController extends GetxController {
  final ProfileRepository _repo = ProfileRepository();

  // OBSERVABLES (State)
  var isLoading = false.obs;
  var currentStep = 0.obs; // To control the Stepper (Step 1, Step 2...)

  // TEXT CONTROLLERS
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final panController = TextEditingController();
  final salaryController = TextEditingController();

  // SELECTIONS
  var selectedEmployment = "Salaried".obs; // Default

  Future<void> submitProfile() async {
    // 1. Validation
    if (nameController.text.isEmpty || panController.text.isEmpty) {
      Get.snackbar("Error", "Please fill all required fields");
      return;
    }

    isLoading.value = true;

    try {
      // 2. Prepare Data
      final data = {
        "full_name": nameController.text,
        "email": emailController.text,
        "pan_number": panController.text
            .toUpperCase(), // PAN is always Uppercase
        "monthly_income": double.tryParse(salaryController.text) ?? 0,
        "employment_type": selectedEmployment.value,
      };

      // 3. Call API
      await _repo.updateProfile(data);

      // 4. Success -> Go to Dashboard
      Get.snackbar("Success", "Profile Created Successfully!");
      Get.offAllNamed(Routes.HOME);
    } catch (e) {
      Get.snackbar("Error", e.toString().replaceAll("Exception: ", ""));
    } finally {
      isLoading.value = false;
    }
  }
}
