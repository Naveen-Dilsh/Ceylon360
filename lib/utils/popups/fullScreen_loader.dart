import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/widgets/loaders/animation_loader.dart';
import '../constants/colors.dart';
import '../helpers/helper_functions.dart';

/// A utility class for managing a full-screen loading dialog.
class TFullScreenLoader {
  /// Open a full-screen loading dialog with a given text and animation.
  /// This method doesn't return anything.
  ///
  /// Parameters:
  /// - text: The text to be displayed in the loading dialog.
  /// - animation: The Lottie animation to be shown.
  static void openLoadingDialog(String text, String animation) {
    showDialog(
      context: Get.overlayContext!, // Use Get.overlayContext for overlay dialogs
      barrierDismissible: false, // The dialog can't be dismissed by tapping outside it
      builder: (_) => PopScope(
        canPop: false, // Disable popping with the back button
        child: Container(
          color: APPHelperFunctions.isDarkMode(Get.context!) ? APPColors.dark : APPColors.white,
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: [
              const SizedBox(height: 200), // Adjust the spacing as needed
              APPAnimationLoaderWidget(text: text, animation: animation)
            ],
          ),
        ),
      ),
    );
  }

  ///stop the currently open loading dialog.
  ///This method doesn't return anything.
  static stopLoading() {
    Navigator.of(Get.overlayContext!).pop();
  }
}
