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
    if (nameController.text.isEmpty ||
        panController.text.isEmpty ||
        salaryController.text.isEmpty) {
      Get.snackbar("Error", "Please fill all required fields");
      return;
    }
    // --- STRICT PAN VALIDATION START ---
    String pan = panController.text.trim().toUpperCase(); // Force Uppercase
    isLoading.value = true;

    final panRegex = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$');

    if (!panRegex.hasMatch(pan)) {
      Get.snackbar(
        "Invalid PAN",
        "PAN must be 5 Letters, 4 Digits, 1 Letter (e.g. ABCDE1234F)",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return; // STOP HERE
    }

    isLoading.value = true;

    try {
      // 2. Prepare Data
      final data = {
        "full_name": nameController.text,
        "email": emailController.text,
        "pan_number": pan, // PAN is always Uppercase
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
