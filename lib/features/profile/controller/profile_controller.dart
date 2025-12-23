import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/profile_repository.dart';
import '../../../core/router/app_routes.dart';

class ProfileController extends GetxController {
  final ProfileRepository _repo = ProfileRepository();

  // OBSERVABLES (State)
  var isLoading = false.obs;
  var currentStep = 0.obs; // To control the Stepper (Step 1, Step 2...)
  var selectedGender = "Male".obs;
  // TEXT CONTROLLERS
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final panController = TextEditingController();
  final salaryController = TextEditingController();
  var userProfile = <String, dynamic>{}.obs;
  var isLoadingProfile = true.obs;
  // SELECTIONS
  var selectedEmployment = "Salaried".obs; // Default

  void goNext() {
    // --- VALIDATION FOR STEP 1 (Basic Details) ---
    if (currentStep.value == 0) {
      if (nameController.text.isEmpty) {
        Get.snackbar("Required", "Please enter your full name");
        return;
      }

      // Strict Email Validation
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegex.hasMatch(emailController.text.trim())) {
        Get.snackbar(
          "Invalid Email",
          "Please enter a valid email (e.g. john@gmail.com)",
        );
        return; // STOP HERE! Do not move to Step 2
      }
    }

    // --- VALIDATION FOR STEP 2 (Employment) ---
    if (currentStep.value == 1) {
      if (salaryController.text.isEmpty) {
        Get.snackbar("Required", "Please enter your income");
        return; // STOP HERE!
      }
    }

    // --- MOVE LOGIC ---
    if (currentStep.value < 2) {
      currentStep.value++; // Move to next step
    } else {
      submitProfile(); // Final Step -> Submit
    }
  }

  Future<void> submitProfile() async {
    // 1. Validation
    if (nameController.text.isEmpty ||
        panController.text.isEmpty ||
        salaryController.text.isEmpty ||
        emailController.text.isEmpty) {
      Get.snackbar("Error", "Please fill all required fields");
      return;
    }

    // 2. EMAIL VALIDATION (Strict)
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(emailController.text.trim())) {
      Get.snackbar("Invalid Email", "Please enter a valid email address");
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
        "gender": selectedGender.value,
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

  void fetchProfileData() async {
    isLoadingProfile.value = true;
    try {
      final data = await _repo.getProfile();
      userProfile.value = data;

      // OPTIONAL: Pre-fill the form fields in case they want to edit immediately
      nameController.text = data['full_name'] ?? "";
      emailController.text = data['email'] ?? "";
      panController.text = data['pan_number'] ?? "";
      salaryController.text = (data['monthly_income'] ?? 0).toString();
      selectedEmployment.value = data['employment_type'] ?? "Salaried";
    } catch (e) {
      print("Error loading profile: $e");
    } finally {
      isLoadingProfile.value = false;
    }
  }
}
