import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../../../data/repositories/user/user_repository.dart';
import '../../../utils/popups/loaders.dart';
import '../../../utils/popups/dialogs.dart';
import '../../authentication/models/user_model.dart';

class UserController extends GetxController {
  static UserController get instance => Get.find();

  final userRepository = Get.put(UserRepository());
  final _auth = FirebaseAuth.instance;

  // Observable user data
  final Rx<UserModel> user = UserModel.empty().obs;
  final RxBool isLoading = false.obs;
  final RxList<String> userMedia = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
  }

  /// Get current authenticated user ID
  String? get currentUserId => _auth.currentUser?.uid;

  /// Save user Record from any Registration provider
  Future<void> saveUserRecord(UserCredential? userCredential) async {
    try {
      isLoading.value = true;

      if (userCredential != null) {
        // Convert name to First and Last Name
        final nameParts = UserModel.nameParts(userCredential.user!.displayName ?? '');
        final username = UserModel.generateUsername(userCredential.user!.displayName ?? '');

        // Map Data
        final newUser = UserModel(
          id: userCredential.user!.uid,
          firstName: nameParts[0],
          lastName: nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '',
          username: username,
          email: userCredential.user!.email ?? '',
          phoneNumber: userCredential.user!.phoneNumber ?? '',
          profilePicture: userCredential.user!.photoURL ?? '',
        );

        // Save user data to Firestore
        await userRepository.saveUserRecord(newUser);
        user.value = newUser;
      }
    } catch (e) {
      APPLoaders.warningSnackBar(
        title: 'Data not saved',
        message: 'Something went wrong while saving your information. You can re-save your data in your Profile.',
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetch current user data
  Future<void> fetchUserData() async {
    try {
      isLoading.value = true;

      if (currentUserId != null) {
        final userData = await userRepository.getUserData(currentUserId!);
        user.value = userData;
        userMedia.value = userData.mediaUrls;
      }
    } catch (e) {
      APPDialogs.errorDialog(
        title: 'Error',
        message: 'Failed to fetch user data: $e',
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Update user profile
  Future<void> updateUserData({
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? username,
  }) async {
    try {
      isLoading.value = true;

      if (currentUserId == null) {
        APPLoaders.warningSnackBar(
          title: 'Not authenticated',
          message: 'Please login to update your profile.',
        );
        return;
      }

      // Create updated user model
      final updatedUser = user.value.copyWith(
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phoneNumber,
        username: username,
        updatedAt: DateTime.now(),
      );

      // Update in Firestore
      await userRepository.updateUserData(updatedUser);

      // Update local user data
      user.value = updatedUser;

      APPLoaders.successSnackBar(
        title: 'Profile Updated',
        message: 'Your profile has been updated successfully.',
      );
    } catch (e) {
      APPLoaders.errorSnackBar(
        title: 'Update Failed',
        message: 'Failed to update profile: $e',
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Upload profile picture
  Future<void> uploadProfilePicture(File imageFile) async {
    try {
      isLoading.value = true;

      if (currentUserId == null) {
        APPLoaders.warningSnackBar(
          title: 'Not authenticated',
          message: 'Please login to update your profile picture.',
        );
        return;
      }

      // Upload to Cloudinary and update Firestore
      final imageUrl = await userRepository.uploadProfilePicture(currentUserId!, imageFile);

      // Update local user data
      user.value = user.value.copyWith(
        profilePicture: imageUrl,
        updatedAt: DateTime.now(),
      );

      APPLoaders.successSnackBar(
        title: 'Profile Picture Updated',
        message: 'Your profile picture has been updated successfully.',
      );
    } catch (e) {
      APPLoaders.errorSnackBar(
        title: 'Upload Failed',
        message: 'Failed to upload profile picture: $e',
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Add media to user's collection
  Future<void> addUserMedia(File mediaFile, {Map<String, dynamic>? metadata}) async {
    try {
      isLoading.value = true;

      if (currentUserId == null) {
        APPLoaders.warningSnackBar(
          title: 'Not authenticated',
          message: 'Please login to add media.',
        );
        return;
      }

      // Upload to Cloudinary and update Firestore
      final mediaUrl = await userRepository.addUserMedia(currentUserId!, mediaFile, metadata: metadata);

      // Update local media list
      userMedia.add(mediaUrl);

      APPLoaders.successSnackBar(
        title: 'Media Added',
        message: 'Your media has been added successfully.',
      );

      // Refresh user data to get updated media list and metadata
      await fetchUserData();
    } catch (e) {
      APPLoaders.errorSnackBar(
        title: 'Upload Failed',
        message: 'Failed to upload media: $e',
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Remove media from user's collection
  Future<void> removeUserMedia(String mediaUrl) async {
    try {
      isLoading.value = true;

      if (currentUserId == null) {
        APPLoaders.warningSnackBar(
          title: 'Not authenticated',
          message: 'Please login to remove media.',
        );
        return;
      }

      // Delete from Cloudinary and update Firestore
      await userRepository.removeUserMedia(currentUserId!, mediaUrl);

      // Update local media list
      userMedia.remove(mediaUrl);

      APPLoaders.successSnackBar(
        title: 'Media Removed',
        message: 'Your media has been removed successfully.',
      );

      // Refresh user data to get updated media list and metadata
      await fetchUserData();
    } catch (e) {
      APPLoaders.errorSnackBar(
        title: 'Removal Failed',
        message: 'Failed to remove media: $e',
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Setup a stream for real-time user data updates
  void listenToUserChanges() {
    if (currentUserId != null) {
      userRepository.streamUserData(currentUserId!).listen(
        (updatedUser) {
          user.value = updatedUser;
          userMedia.value = updatedUser.mediaUrls;
        },
        onError: (e) {
          print('Error listening to user changes: $e');
        },
      );
    }
  }
}
