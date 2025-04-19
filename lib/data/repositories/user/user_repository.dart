import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../features/authentication/models/user_model.dart';
import '../../../utils/exceptions/exception.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Function to save user data to Firestore
  Future<void> saveUserRecord(UserModel user) async {
    try {
      await _firestore.collection('Users').doc(user.id).set(user.toJson());
    } on FirebaseException catch (e) {
      throw APPFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const APPFormatException();
    } on PlatformException catch (e) {
      throw APPPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }
}
