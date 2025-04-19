import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../features/authentication/screens/login/login.dart';
import '../../../features/authentication/screens/onboarding/onboarding.dart';
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
    //local storage
    if (kDebugMode) {
      print('===========Get storage Auth Repo===========');
      print(deviceStorage.read('IsFirstTime'));
    }

    deviceStorage.writeIfNull('IsFirstTime', true);
    deviceStorage.read('IsFirstTime') != true
        ? Get.offAll(() => const LoginScreen())
        : Get.offAll(() => const OnboardingScreen());
  }

  /*--------------------------------Email & Password sign in--------------------------------*/
  /// [EmailAuthentication] - SignIn
  ///
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
  /// [ReAuthenticate] - ReAuthenticate User
  /// [EmailAuthentication] - Forget Password
  /*--------------------------------Federated identity & social sign-in--------------------------------*/

  /// [GoogleAuthentication] - Google
  /// [FacebookAuthentication] - Facebook
  /*--------------------------------./end Federated identity & social sign-in--------------------------------*/

  /// [LogoutUser] - Valid for any authentication
  /// [DeleteUser] - Remove user Auth and Firestore Account
}
