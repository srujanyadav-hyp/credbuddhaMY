import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../data/profile_repository.dart';
import '../../../core/router/app_routes.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class ProfileController extends GetxController {
  final ProfileRepository _repo = ProfileRepository();
  final _storage = GetStorage(); // Access local storage

  @override
  void onInit() {
    super.onInit();
    prefillPhoneFromLogin();
    checkIfEditing();
  }

  // OBSERVABLES (State)
  var isLoading = false.obs;
  var currentStep = 0.obs;
  var selectedGender = "Male".obs;

  // TEXT CONTROLLERS
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final panController = TextEditingController();
  final salaryController = TextEditingController();
  final loanAmountController = TextEditingController();

  var userProfile = <String, dynamic>{}.obs;
  var isLoadingProfile = true.obs;

  final addressController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final pincodeController = TextEditingController();

  // SELECTIONS
  var selectedEmployment = "Salaried".obs;

  // --- LOGOUT FUNCTION ---
  void logout() {
    final storage = GetStorage();
    storage.erase();
    Get.offAllNamed(Routes.LOGIN);
  }

  // LOGIC: Get Login Phone from Storage
  void prefillPhoneFromLogin() {
    var userData = _storage.read('user_data');
    // userData is usually a Map: {'id': 1, 'phone': '9876543210', ...}
    if (userData != null && userData['phone'] != null) {
      phoneController.text = userData['phone'].toString();
    }
  }

  void checkIfEditing() {
    if (userProfile.isNotEmpty) {
      nameController.text = userProfile['full_name'] ?? "";
      emailController.text = userProfile['email'] ?? "";
      panController.text = userProfile['pan_number'] ?? "";

      // Pre-fill Phone & Loan Amount if editing
      if (userProfile['phone'] != null)
        phoneController.text = userProfile['phone'];
      if (userProfile['loan_amount'] != null) {
        loanAmountController.text = userProfile['loan_amount'].toString();
      }

      addressController.text = userProfile['address'] ?? "";
      cityController.text = userProfile['city'] ?? "";
      stateController.text = userProfile['state'] ?? "";
      pincodeController.text = userProfile['pincode'] ?? "";

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
    // --- STEP 1: BASIC DETAILS (Index 0) ---
    if (currentStep.value == 0) {
      // Check Name and Phone
      if (nameController.text.isEmpty || phoneController.text.isEmpty) {
        if (nameController.text.isEmpty && phoneController.text.isEmpty) {
          Get.snackbar("Required", "Please enter name and phone number");
        } else if (nameController.text.isEmpty) {
          Get.snackbar("Required", "Please enter name");
        } else if (phoneController.text.isEmpty) {
          Get.snackbar("Required", "Please enter phone number");
        }

        return;
      }

      // Strict Email Validation
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegex.hasMatch(emailController.text.trim()) ||
          !emailController.text.trim().endsWith("@gmail.com")) {
        Get.snackbar("Invalid Email", "Please enter a valid Gmail address");
        return;
      }
    }

    // --- STEP 2: ADDRESS DETAILS (Index 1) ---
    if (currentStep.value == 1) {
      if (addressController.text.isEmpty ||
          cityController.text.isEmpty ||
          stateController.text.isEmpty ||
          pincodeController.text.isEmpty) {
        Get.snackbar("Required", "Please fill all address details");
        return;
      }
    }

    // --- STEP 3: EMPLOYMENT (Index 2) ---
    if (currentStep.value == 2) {
      // Check Income and Loan Amount
      if (salaryController.text.isEmpty || loanAmountController.text.isEmpty) {
        Get.snackbar("Required", "Please enter income and loan amount");
        return;
      }
    }

    // --- MOVE LOGIC ---
    if (currentStep.value < 3) {
      currentStep.value++;
    } else {
      submitProfile();
    }
  }

  Future<void> submitProfile() async {
    // 1. Validation (Basic check)
    if (nameController.text.isEmpty ||
        panController.text.isEmpty ||
        salaryController.text.isEmpty ||
        phoneController.text.isEmpty) {
      Get.snackbar("Error", "Please fill all required fields");
      return;
    }

    // PAN Validation
    String pan = panController.text.trim().toUpperCase();
    final panRegex = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$');

    if (!panRegex.hasMatch(pan)) {
      Get.snackbar("Invalid PAN", "PAN must be 5 Letters, 4 Digits, 1 Letter");
      return;
    }

    isLoading.value = true;

    try {
      final data = {
        "full_name": nameController.text,
        "email": emailController.text,
        "phone": phoneController.text, // Send Phone
        "gender": selectedGender.value,
        "pan_number": pan,
        "monthly_income": double.tryParse(salaryController.text) ?? 0,
        "loan_amount":
            double.tryParse(loanAmountController.text) ?? 0, // Send Loan Amount
        "employment_type": selectedEmployment.value,
        "address": addressController.text,
        "city": cityController.text,
        "state": stateController.text,
        "pincode": pincodeController.text,
      };

      await _repo.updateProfile(data);

      Get.snackbar(
        "Success",
        "Profile Updated Successfully!",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
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

      // Populate Phone & Loan
      if (data['phone'] != null) phoneController.text = data['phone'];
      if (data['loan_amount'] != null) {
        loanAmountController.text = data['loan_amount'].toString();
      }

      addressController.text = data['address'] ?? "";
      cityController.text = data['city'] ?? "";
      stateController.text = data['state'] ?? "";
      pincodeController.text = data['pincode'] ?? "";

      if (data['monthly_income'] != null) {
        salaryController.text = data['monthly_income'].toString();
      }

      selectedEmployment.value = data['employment_type'] ?? "Salaried";
      if (data['gender'] != null) selectedGender.value = data['gender'];
    } catch (e) {
      print("Error loading profile: $e");
    } finally {
      isLoadingProfile.value = false;
    }
  }

  // --- AUTO-FILL ADDRESS ---
  Future<void> fetchCurrentAddress() async {
    isLoading.value = true;
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Get.snackbar("Permission Denied", "Location permission is required.");
          isLoading.value = false;
          return;
        }
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
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
