import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../features/authentication/screens/login/login.dart';
import '../../../features/authentication/screens/onboarding/onboarding.dart';
import '../../../features/authentication/screens/signup/verify_email.dart';
import '../../../features/personalization/controllers/user_controller.dart';
import '../../../home.dart';
import '../../../utils/exceptions/exception.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  ///variables
  final deviceStorage = GetStorage();
  final _auth = FirebaseAuth.instance;

  ///Called from main.dart on app launch
  @override
  void onReady() {
    FlutterNativeSplash.remove();
    screenRedirect();
  }

  ///Function to Show Relevant Screen on App Launch
  screenRedirect() async {
    final user = _auth.currentUser;
    if (user != null) {
      if (user.emailVerified) {
        Get.offAll(() => const HomePage());
      } else {
        Get.offAll(() => VerifyEmailScreen(
              email: _auth.currentUser?.email,
            ));
      }
    } else {
      //Local Storage
      deviceStorage.writeIfNull('IsFirstTime', true);
      //check if it's the first time launching app
      deviceStorage.read('IsFirstTime') != true
          ? Get.offAll(() => const LoginScreen())
          : Get.offAll(() => const ProfessionalOnboardingScreen());
    }

    // Remove this duplicate code block:
    // deviceStorage.writeIfNull('IsFirstTime', true);
    // deviceStorage.read('IsFirstTime') != true
    //    ? Get.offAll(() => const LoginScreen())
    //    : Get.offAll(() => const OnboardingScreen());
  }

  /*--------------------------------Email & Password sign in--------------------------------*/
  /// [EmailAuthentication] - SignIn
  Future<UserCredential> loginWithEmailAndPassword(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw APPFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw APPFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const APPFormatException();
    } on APPPlatformException catch (e) {
      throw APPPlatformException(e.code).message;
    } catch (e) {
      throw "something went wrong. Please try again later";
    }
  }

  /// [EmailAuthentication] - Register
  Future<UserCredential> registerWithEmailAndPassword(String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw APPFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw APPFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const APPFormatException();
    } on APPPlatformException catch (e) {
      throw APPPlatformException(e.code).message;
    } catch (e) {
      throw "something went wrong. Please try again later";
    }
  }

  /// [EmailAuthentication] - Mail Verification
  Future<void> sendEmailVerification() async {
    try {
      await _auth.currentUser?.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      throw APPFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw APPFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const APPFormatException();
    } on APPPlatformException catch (e) {
      throw APPPlatformException(e.code).message;
    } catch (e) {
      throw "something went wrong. Please try again later";
    }
  }

  /// [ReAuthenticate] - ReAuthenticate User
  /// [EmailAuthentication] - Forget Password
  /*--------------------------------Federated identity & social sign-in--------------------------------*/

  /// [GoogleAuthentication] - Google
  /// [GoogleAuthentication] - Google
  Future<UserCredential> signInWithGoogle() async {
    try {
      print('Starting Google Sign-In process');
      // Trigger the authentication flow
      final GoogleSignInAccount? userAccount = await GoogleSignIn().signIn();

      if (userAccount == null) {
        print('User cancelled the sign-in process');
        throw 'Google Sign-In was cancelled by the user';
      }

      print('Google Sign-In account obtained: ${userAccount.email}');

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth = await userAccount?.authentication;
      print('Google authentication obtained');

      // Create a new credential
      final credentials = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      print('Google credentials created');

      final userCredential = await _auth.signInWithCredential(credentials);
      print('Firebase authentication successful');

      // ADDED: Handle user document creation
      final userController = Get.put(UserController());

      if (userCredential.additionalUserInfo?.isNewUser == true) {
        // New user - create document
        print('New Google user detected, creating user document');
        await userController.saveUserRecord(userCredential);
      } else {
        // Existing user - ensure document exists
        print('Existing Google user detected, checking document');
        try {
          await userController.fetchUserData();
          print('User document found');
        } catch (e) {
          print('User document not found, creating one');
          await userController.saveUserRecord(userCredential);
        }
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw APPFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw APPFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const APPFormatException();
    } on APPPlatformException catch (e) {
      throw APPPlatformException(e.code).message;
    } catch (e) {
      throw "something went wrong. Please try again later";
    }
  }

  /// [FacebookAuthentication] - Facebook
  /*--------------------------------./end Federated identity & social sign-in--------------------------------*/

  /// [LogoutUser] - Valid for any authentication
  Future<void> logout() async {
    try {
      await GoogleSignIn().signOut();
      await FirebaseAuth.instance.signOut();
    } on FirebaseAuthException catch (e) {
      throw APPFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw APPFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const APPFormatException();
    } on APPPlatformException catch (e) {
      throw APPPlatformException(e.code).message;
    } catch (e) {
      throw "something went wrong. Please try again later";
    }
  }
}
