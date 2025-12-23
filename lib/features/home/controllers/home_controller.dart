import 'package:get/get.dart';
import '../data/home_repository.dart';

class HomeController extends GetxController {
  final HomeRepository _repo = HomeRepository();

  // OBSERVABLES
  var isLoading = true.obs;
  var userName = "".obs;
  var loanOffers = <dynamic>[].obs; // List of loans
  var errorMessage = "".obs;

  @override
  void onInit() {
    super.onInit();
    fetchDashboard();
  }

  void fetchDashboard() async {
    isLoading.value = true;
    errorMessage.value = "";

    try {
      final data = await _repo.getDashboardData();

      // Update State
      userName.value = data['user_name'] ?? "User";
      loanOffers.value = data['eligible_loans'] ?? [];
    } catch (e) {
      errorMessage.value = "Could not load data. Pull to refresh.";
      print("Home Error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
