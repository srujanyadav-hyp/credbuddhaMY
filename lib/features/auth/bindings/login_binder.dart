import 'package:credbuddha/features/auth/controllers/otp_contorller.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';
import '../data/auth_repository.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    // --- Put the Repository first (Logic Layer) --- //
    // --- We use Get.put because the Controller needs it immediately ---//
    Get.put(AuthRepository());

    // --- Put the Controller (State Layer)--- //
    // --- We use LazyPut to save memory until the screen actually loads -- //
    Get.lazyPut<LoginController>(() => LoginController());
    Get.lazyPut<OtpController>(() => OtpController());
  }
}
