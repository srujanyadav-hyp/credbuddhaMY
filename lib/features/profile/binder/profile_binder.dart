import 'package:get/get.dart';
import '../controller/profile_controller.dart';
import '../data/profile_repository.dart';

class ProfileBinder extends Bindings {
  @override
  void dependencies() {
    // --- Put the Repository first (Logic Layer) --- //
    // --- We use Get.put because the Controller needs it immediately ---//
    Get.put(ProfileRepository());

    // --- Put the Controller (State Layer)--- //
    // --- We use LazyPut to save memory until the screen actually loads -- //
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}
