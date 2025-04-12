import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingController extends GetxController {
  // Variables
  final pageController = PageController();
  final currentPage = 0.obs;
  final totalPages = 3;

  // Methods
  void updatePageIndicator(int index) {
    currentPage.value = index;
  }

  void nextPage() {
    if (currentPage.value == totalPages - 1) {
      // If on last page, navigate to login screen
      navigateToLogin();
    } else {
      // Otherwise go to next page
      int page = currentPage.value + 1;
      pageController.animateToPage(
        page,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void skipToLastPage() {
    pageController.animateToPage(
      totalPages - 1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void navigateToLogin() {}
}
