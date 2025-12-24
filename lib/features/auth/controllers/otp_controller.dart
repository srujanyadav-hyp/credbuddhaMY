import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../data/auth_repository.dart';
import '../../../core/router/app_routes.dart';

class OtpController extends GetxController {
  final AuthRepository _repo = AuthRepository();
  final _storage = GetStorage();

  var isLoading = false.obs;
  var errorMessage = ''.obs;

  late String phoneNumber;

  @override
  void onInit() {
    super.onInit();
    // Retrieve phone passed from Login Screen
    phoneNumber = Get.arguments['phone'] ?? '';
  }

  Future<void> verifyOtp(String otp) async {
    // 1. Validation
    if (otp.length != 6) {
      Get.snackbar(
        "Error",
        "Please enter 6 digits",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      // 2. Call Repository
      // The Repository handles the API call. If it returns, it means Status Code was 200.
      // If Status was 400/500, it throws an exception, going to 'catch'.
      final data = await _repo.verifyOtp(phoneNumber, otp);

      // 3. Save Data locally
      if (data['token'] != null) {
        await _storage.write('auth_token', data['token']);
      }

      if (data['user'] != null) {
        // We save the user map directly (ProfileRepository handles this format now)
        await _storage.write('user_data', data['user']);
      }

      Get.snackbar(
        "Success",
        "Login Successful",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // --- 4. SMART NAVIGATION LOGIC (Your Logic) ---

      // Check the flag from backend (Default to false if null)
      bool isProfileComplete = false;

      if (data['user'] != null && data['user']['profile_complete'] != null) {
        isProfileComplete = data['user']['profile_complete'];
      }

      if (isProfileComplete) {
        // EXISTING USER -> Go to Dashboard
        Get.offAllNamed(Routes.HOME);
      } else {
        // NEW USER -> Go to Profile Creation
        Get.offAllNamed(Routes.PROFILE_CREATE);
      }
      // ---------------------------------------------
    } catch (e) {
      // Handle Errors (Invalid OTP, Network issues, etc.)
      errorMessage.value = e.toString().replaceAll("Exception: ", "");
      Get.snackbar(
        "Error",
        errorMessage.value,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
