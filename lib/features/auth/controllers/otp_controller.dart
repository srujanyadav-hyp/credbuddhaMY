import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart'; // To save the token
import '../data/auth_repository.dart';
import '../../../core/router/app_routes.dart';

class OtpController extends GetxController {
  final AuthRepository _repo = AuthRepository();
  final _storage = GetStorage(); // The storage box

  var isLoading = false.obs;
  var errorMessage = ''.obs;

  // Received from previous screen
  late String phoneNumber;

  @override
  void onInit() {
    super.onInit();
    // Get the phone number passed from Login Screen
    phoneNumber = Get.arguments['phone'] ?? '';
  }

  Future<void> verifyOtp(String otp) async {
    if (otp.length != 6) {
      errorMessage.value = "Please enter 6 digits";
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      // 1. Call API
      final data = await _repo.verifyOtp(phoneNumber, otp);

      // 2. SAVE TOKEN (Crucial Step!)
      // This keeps the user logged in even if they close the app.
      String token = data['token'];
      await _storage.write('user_token', token);
      await _storage.write('user_data', data['user']);

      bool isProfileComplete = data['user']['profile_complete'] ?? false;

      if (isProfileComplete) {
        Get.offAllNamed(Routes.HOME);
      } else {
        Get.offAllNamed(Routes.PROFILE_CREATE); // Send to our new screen
      }
      // 3. Navigate to Dashboard (Remove all previous screens)
      Get.offAllNamed(Routes.HOME); // You need to define this route later
    } catch (e) {
      errorMessage.value = e.toString().replaceAll("Exception: ", "");
    } finally {
      isLoading.value = false;
    }
  }
}
