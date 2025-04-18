import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/services/network_manager.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/popups/fullScreen_loader.dart';
import '../../../../utils/popups/loaders.dart';

class SignupController extends GetxController {
  static SignupController get instance => Get.find();

  /// Variables
  final hidePassword = true.obs; //hide password variable
  final privacyPolicy = true.obs; //privacy policy variable
  final email = TextEditingController(); //controller for email input
  final lastName = TextEditingController(); //controller for last name input
  final firstName = TextEditingController(); //controller for first name input
  final username = TextEditingController(); //controller for username input
  final password = TextEditingController(); //controller for password input
  final phoneNumber = TextEditingController(); //controller for phone number input
  GlobalKey<FormState> signupFormKey = GlobalKey<FormState>(); //form key for form validation

  ///-- SIGNUP FORM CONTROLLER --///
  Future<void> signup() async {
    try {
      // start Loading
      APPFullScreenLoader.openLoadingDialog('We are processing Your information...', APPImages.docerAnimation);

      // check Internet Connection
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) return;

      // Form Validation
      if (!signupFormKey.currentState!.validate()) {
        return;
      }

      // Privacy Policy Check
      if (!privacyPolicy.value) {
        APPLoaders.warningSnackBar(
          title: 'Accept Privacy Policy',
          message: 'Please accept the privacy policy to continue',
        );
        return;
      }

      // Register user in the firebase Authentication & Save user data in Firebase

      // Save Authenticated user data in the Firebase Firestore

      // Show success message

      // Move to verify Email screen
    } catch (e) {
      // Show some Generic Error to the user
      APPLoaders.errorSnackBar(title: 'oh Snap!', message: e.toString());
    } finally {
      // Remove Loader
      APPFullScreenLoader.stopLoading();
    }
  }
}
