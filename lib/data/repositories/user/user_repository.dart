import 'dart:io';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../features/authentication/models/user_model.dart';
import '../../../utils/exceptions/exception.dart';
import '../../services/cloudinary/cloudinary_service.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CloudinaryService _cloudinaryService = Get.put(CloudinaryService());

  // Collection reference
  CollectionReference<Map<String, dynamic>> get _usersCollection => _firestore.collection('Users');

  /// Create - Save user data to Firestore
  Future<void> saveUserRecord(UserModel user) async {
    try {
      await _usersCollection.doc(user.id).set(user.toJson());
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

  /// Read - Get user data from Firestore
  Future<UserModel> getUserData(String userId) async {
    try {
      final documentSnapshot = await _usersCollection.doc(userId).get();
      if (documentSnapshot.exists) {
        return UserModel.fromSnapshot(documentSnapshot);
      } else {
        throw 'User not found';
      }
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

  /// Update - Update user data in Firestore
  Future<void> updateUserData(UserModel user) async {
    try {
      await _usersCollection.doc(user.id).update(user.toJson());
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

  /// Delete - Delete user from Firestore
  Future<void> deleteUser(String userId) async {
    try {
      // First, get the user data to access media URLs
      final user = await getUserData(userId);

      // Delete profile picture from Cloudinary if exists
      if (user.profilePicture.isNotEmpty && user.profilePicture.contains('cloudinary')) {
        await _cloudinaryService.deleteImage(user.profilePicture);
      }

      // Delete all media from Cloudinary
      for (final mediaUrl in user.mediaUrls) {
        if (mediaUrl.contains('cloudinary')) {
          await _cloudinaryService.deleteImage(mediaUrl);
        }
      }

      // Finally, delete the user document from Firestore
      await _usersCollection.doc(userId).delete();
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

  /// Upload profile picture to Cloudinary and update user record
  /// Upload profile picture to Cloudinary and update user record
  Future<String> uploadProfilePicture(String userId, File imageFile) async {
    try {
      // Upload image to Cloudinary
      final imageUrl = await _cloudinaryService.uploadImage(imageFile);

      // FIXED: Use set with merge instead of update
      await _usersCollection.doc(userId).set({
        'ProfilePicture': imageUrl,
        'UpdatedAt': Timestamp.fromDate(DateTime.now()),
      }, SetOptions(merge: true));

      return imageUrl;
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

  /// Add media to user's collection
  Future<String> addUserMedia(String userId, File mediaFile, {Map<String, dynamic>? metadata}) async {
    try {
      // Upload media to Cloudinary
      final mediaUrl = await _cloudinaryService.uploadImage(mediaFile);

      // Get current user data
      final userDoc = await _usersCollection.doc(userId).get();
      final userData = userDoc.data() ?? {};

      // Update media arrays
      List<String> currentMediaUrls = List<String>.from(userData['MediaUrls'] ?? []);
      currentMediaUrls.add(mediaUrl);

      Map<String, dynamic> currentMetadata = Map<String, dynamic>.from(userData['MediaMetadata'] ?? {});
      if (metadata != null) {
        currentMetadata[mediaUrl] = metadata;
      }

      // Update Firestore
      await _usersCollection.doc(userId).update({
        'MediaUrls': currentMediaUrls,
        'MediaMetadata': currentMetadata,
        'UpdatedAt': Timestamp.fromDate(DateTime.now()),
      });

      return mediaUrl;
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

  /// Remove media from user's collection
  Future<void> removeUserMedia(String userId, String mediaUrl) async {
    try {
      // Delete from Cloudinary
      if (mediaUrl.contains('cloudinary')) {
        await _cloudinaryService.deleteImage(mediaUrl);
      }

      // Get current user data
      final userDoc = await _usersCollection.doc(userId).get();
      final userData = userDoc.data() ?? {};

      // Update media arrays
      List<String> currentMediaUrls = List<String>.from(userData['MediaUrls'] ?? []);
      currentMediaUrls.remove(mediaUrl);

      Map<String, dynamic> currentMetadata = Map<String, dynamic>.from(userData['MediaMetadata'] ?? {});
      currentMetadata.remove(mediaUrl);

      // Update Firestore
      await _usersCollection.doc(userId).update({
        'MediaUrls': currentMediaUrls,
        'MediaMetadata': currentMetadata,
        'UpdatedAt': Timestamp.fromDate(DateTime.now()),
      });
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

  /// Stream user data for real-time updates
  Stream<UserModel> streamUserData(String userId) {
    try {
      return _usersCollection.doc(userId).snapshots().map((snapshot) {
        if (snapshot.exists) {
          return UserModel.fromSnapshot(snapshot);
        } else {
          throw 'User not found';
        }
      });
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }
}
