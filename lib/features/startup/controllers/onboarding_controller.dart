import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/router/app_routes.dart';
import '../models/onboarding_model.dart';

class OnboardingController extends GetxController {
  // 1. Page Controller for the PageView
  final pageController = PageController();

  // 2. State Variable: Which page is currently visible?
  var selectedPageIndex = 0.obs;

  @override
  void onInit() {
    print("🚀 DEBUG: OnboardingController onInit called!"); // <--- Add this
    super.onInit();
    // ... rest of your code
  }

  // 3. The Data for your 3 Slides
  final List<OnboardingModel> pages = [
    OnboardingModel(
      image: 'assets/images/onboarding_1.png',
      title: 'Instant Loan Approval',
      description:
          'Get your loan approved in minutes with our AI-powered engine. No paperwork required.',
    ),
    OnboardingModel(
      image: 'assets/images/onboarding_2.png',
      title: 'Compare Best Offers',
      description:
          'We check 50+ banks to find the lowest interest rates tailored just for you.',
    ),
    OnboardingModel(
      image: 'assets/images/onboarding_3.png',
      title: '100% Secure & Safe',
      description:
          'Your data is encrypted with bank-grade security. We value your privacy.',
    ),
  ];

  // 4. Update the index when user swipes
  void updatePage(int index) {
    selectedPageIndex.value = index;
  }

  // 5. Logic for "Next" Button
  void forwardAction() {
    if (selectedPageIndex.value == pages.length - 1) {
      // If on last page, finish onboarding
      completeOnboarding();
    } else {
      // Otherwise, slide to next page
      pageController.nextPage(duration: 300.milliseconds, curve: Curves.ease);
    }
  }

  // 6. Logic for "Skip" / Finish
  Future<void> completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seen_onboarding', true);
    Get.offNamed(Routes.LOGIN);
  }
}
