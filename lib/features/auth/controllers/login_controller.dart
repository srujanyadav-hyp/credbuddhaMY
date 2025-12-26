import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/auth_repository.dart';
import '../../../core/router/app_routes.dart';

class LoginController extends GetxController {
  final AuthRepository _repo = AuthRepository();

  // --- Controllers for Text Fields --- //
  final phoneController = TextEditingController();

  // --- Observables (State) --- //
  var isLoading = false.obs;
  var errorMessage = ''.obs; // To show errors under the text field
  var isButtonEnabled = false.obs; // Validation State

  @override
  void onInit() {
    super.onInit();
    // --- Listen to text changes to enable/disable button --- //
    phoneController.addListener(_validateInput);
  }

  // --- LIVE VALIDATION (The Customer loves feedback) --- //
  void _validateInput() {
    String text = phoneController.text;
    // Rule: Must be exactly 10 digits
    RegExp indianMobileRegex = RegExp(r'^[6-9]\d{9}$');

    if (indianMobileRegex.hasMatch(text)) {
      isButtonEnabled.value = true;
      errorMessage.value = ''; // Valid
    } else {
      isButtonEnabled.value = false;
      // Optional: Show error only if they have typed 10 digits but it's wrong
      if (text.length == 10) {
        errorMessage.value = "Please enter a valid Indian mobile number";
      } else {
        errorMessage.value = ""; // Don't annoy them while typing
      }
    }
  }

  Future<void> sendOtp() async {
    //  HIDE KEYBOARD (UX Polish)
    FocusManager.instance.primaryFocus?.unfocus();

    // Remove spaces, dashes, +91, etc.
    String cleanPhone = phoneController.text.trim().replaceAll(
      RegExp(r'[^0-9]'),
      '',
    );

    // C. START LOADING
    isLoading.value = true;
    errorMessage.value = '';

    try {
      // CALL API
      await _repo.sendOtp(cleanPhone);

      //  SUCCESS -> Move to OTP Screen
      Get.toNamed(Routes.OTP, arguments: {'phone': cleanPhone});
      // Get.toNamed(Routes.PROFILE_CREATE);
    } catch (e) {
      // HANDLE ERRORS GRACEFULLY
      errorMessage.value = "Something went wrong. Please try again.";

      Get.snackbar(
        "Connection Error",
        "We couldn't reach the server. Check your internet.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      // G. STOP LOADING (Always run this)
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    phoneController.dispose();
    super.onClose();
  }
}
