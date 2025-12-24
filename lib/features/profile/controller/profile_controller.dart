import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart'; // 1. IMPORT THIS
import '../data/profile_repository.dart';
import '../../../core/router/app_routes.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class ProfileController extends GetxController {
  final ProfileRepository _repo = ProfileRepository();

  @override
  void onInit() {
    super.onInit();
    checkIfEditing();
  }

  // OBSERVABLES (State)
  var isLoading = false.obs;
  var currentStep = 0.obs;
  var selectedGender = "Male".obs;

  // TEXT CONTROLLERS
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final panController = TextEditingController();
  final salaryController = TextEditingController();

  var userProfile = <String, dynamic>{}.obs;
  var isLoadingProfile = true.obs;
  final addressController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final pincodeController = TextEditingController();

  // SELECTIONS
  var selectedEmployment = "Salaried".obs;

  // --- LOGOUT FUNCTION (NEW) ---
  void logout() {
    final storage = GetStorage();
    storage.erase(); // 1. Clear all local data (User, Token, etc.)
    Get.offAllNamed(Routes.LOGIN); // 2. Navigate to Login (Remove history)
  }
  // -----------------------------

  void checkIfEditing() {
    if (userProfile.isNotEmpty) {
      nameController.text = userProfile['full_name'] ?? "";
      emailController.text = userProfile['email'] ?? "";
      panController.text = userProfile['pan_number'] ?? "";

      if (userProfile['monthly_income'] != null) {
        salaryController.text = userProfile['monthly_income'].toString();
      }

      if (userProfile['employment_type'] != null) {
        selectedEmployment.value = userProfile['employment_type'];
      }

      if (userProfile['gender'] != null) {
        selectedGender.value = userProfile['gender'];
      }
    }
  }

  void enableEditMode() {
    checkIfEditing();
    Get.toNamed(Routes.PROFILE_CREATE);
  }

  void goNext() {
    // STEP 1 VALIDATION
    if (currentStep.value == 0) {
      if (nameController.text.isEmpty) {
        Get.snackbar("Required", "Please enter your full name");
        return;
      }

      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegex.hasMatch(emailController.text.trim()) ||
          !emailController.text.trim().endsWith("@gmail.com")) {
        Get.snackbar("Invalid Email", "Please enter a valid email");
        return;
      }
    }

    // STEP 2 VALIDATION
    if (currentStep.value == 1) {
      if (salaryController.text.isEmpty) {
        Get.snackbar("Required", "Please enter your income");
        return;
      }
    }

    // MOVE LOGIC
    if (currentStep.value < 2) {
      currentStep.value++;
    } else {
      submitProfile();
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

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(emailController.text.trim()) ||
        !emailController.text.trim().endsWith("@gmail.com")) {
      Get.snackbar("Invalid Email", "Please enter a valid email address");
      return;
    }

    // PAN Validation
    String pan = panController.text.trim().toUpperCase();
    final panRegex = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$');

    if (!panRegex.hasMatch(pan)) {
      Get.snackbar(
        "Invalid PAN",
        "PAN must be 5 Letters, 4 Digits, 1 Letter (e.g. ABCDE1234F)",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;

    try {
      final data = {
        "full_name": nameController.text,
        "email": emailController.text,
        "gender": selectedGender.value,
        "pan_number": pan,
        "monthly_income": double.tryParse(salaryController.text) ?? 0,
        "employment_type": selectedEmployment.value,
      };

      await _repo.updateProfile(data);

      Get.snackbar(
        "Success",
        "Profile Updated Successfully!",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Navigate to Home
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

      nameController.text = data['full_name'] ?? "";
      emailController.text = data['email'] ?? "";
      panController.text = data['pan_number'] ?? "";
      salaryController.text = (data['monthly_income'] ?? 0).toString();
      selectedEmployment.value = data['employment_type'] ?? "Salaried";
      if (data['gender'] != null) selectedGender.value = data['gender'];
    } catch (e) {
      print("Error loading profile: $e");
    } finally {
      isLoadingProfile.value = false;
    }
  }

  // --- NEW: AUTO-FILL ADDRESS FUNCTION ---
  Future<void> fetchCurrentAddress() async {
    isLoading.value = true;
    try {
      // 1. Check Permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Get.snackbar("Permission Denied", "Location permission is required.");
          isLoading.value = false;
          return;
        }
      }

      // 2. Get GPS Position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // 3. Convert GPS -> Address (Reverse Geocoding)
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];

        // 4. Auto-Fill the Text Fields
        addressController.text = "${place.street}, ${place.subLocality}";
        cityController.text = place.locality ?? "";
        stateController.text = place.administrativeArea ?? "";
        pincodeController.text = place.postalCode ?? "";

        Get.snackbar("Success", "Address fetched: ${place.locality}");
      }
    } catch (e) {
      Get.snackbar("Error", "Could not fetch location: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
