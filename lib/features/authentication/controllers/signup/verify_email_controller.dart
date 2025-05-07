import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import '../../../../common/widgets/success_screen/success_screen.dart';
import '../../../../data/repositories/authentication/authentication_repository.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../../../utils/popups/loaders.dart';

class VerifyEmailController extends GetxController {
  static VerifyEmailController get instance => Get.find();

  /// Send Email WhenEver Verify Screen Appears & set timer for auto redirect
  @override
  void onInit() {
    sendEmailVerification();
    setTimerForAutoRedirect();
    super.onInit();
  }

  /// Send Email Verification Link
  sendEmailVerification() async {
    try {
      await AuthenticationRepository.instance.sendEmailVerification();
      APPLoaders.successSnackBar(
          title: "Email Sent", message: "Verification email has been sent to your email address.");
    } catch (e) {
      APPLoaders.errorSnackBar(title: "Error", message: e.toString());
    }
  }

  /// Timer to automatically redirect on Email Verification
  setTimerForAutoRedirect() {
    Timer.periodic(const Duration(seconds: 1), (timer) async {
      await FirebaseAuth.instance.currentUser?.reload();
      final user = FirebaseAuth.instance.currentUser;
      if (user?.emailVerified ?? false) {
        timer.cancel();
        Get.off(() => SuccessScreen(
              image: APPImages.deliveredEmailIllustration,
              title: "Email Verified",
              subTitle: "Your account has been created successfully",
              onPressed: () => AuthenticationRepository.instance.screenRedirect(),
            ));
      }
    });
  }

  /// Manually Check if Email Verified
  checkEmailVerificationStatus() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null && currentUser.emailVerified) {
      Get.off(() => SuccessScreen(
            image: APPImages.deliveredEmailIllustration,
            title: "Check Your Inbox",
            subTitle:
                " We have sent a verification link to your email account. Please click the link to verify your email address and continue your registration process.",
            onPressed: () => AuthenticationRepository.instance.screenRedirect(),
          ));
    } else {
      APPLoaders.errorSnackBar(title: "Error", message: "Email not verified yet. Please check your inbox.");
    }
  }
}
