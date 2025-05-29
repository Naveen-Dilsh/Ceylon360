import 'dart:io';
import 'package:ceyloan_360/features/personalization/screens/updateProfile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../../../data/repositories/authentication/authentication_repository.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/constants/image_strings.dart';
import '../../../utils/helpers/helper_functions.dart';
import '../../../utils/popups/dialogs.dart';
import '../../../utils/popups/loaders.dart';
import '../../authentication/screens/login/login.dart';
import '../controllers/user_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserController());
    final dark = APPHelperFunctions.isDarkMode(context);

    return Scaffold(
      body: Stack(
        children: [
          // Background with Ceylon theme
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  APPColors.primary,
                  APPColors.ceylonTeal,
                  dark ? APPColors.dark : APPColors.light,
                ],
                stops: const [0.0, 0.3, 1.0],
              ),
            ),
          ),

          // Content
          SafeArea(
            child: Obx(
              () => controller.isLoading.value
                  ? const Center(child: CircularProgressIndicator(color: APPColors.white))
                  : CustomScrollView(
                      slivers: [
                        // Custom App Bar
                        SliverAppBar(
                          expandedHeight: 120,
                          floating: false,
                          pinned: true,
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          leading: IconButton(
                            icon: const Icon(Iconsax.arrow_left, color: APPColors.white),
                            onPressed: () => Get.back(),
                          ),
                          actions: [
                            IconButton(
                              icon: const Icon(Iconsax.edit, color: APPColors.white),
                              onPressed: () => Get.to(() => const UpdateProfileScreen()),
                            ),
                            IconButton(
                              icon: const Icon(Iconsax.logout, color: APPColors.white),
                              onPressed: () => _showLogoutDialog(context, controller),
                            ),
                          ],
                          flexibleSpace: FlexibleSpaceBar(
                            title: Text(
                              'My Profile',
                              style: TextStyle(
                                color: APPColors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            centerTitle: true,
                          ),
                        ),

                        // Profile Content
                        SliverToBoxAdapter(
                          child: Column(
                            children: [
                              _buildProfileHeader(context, controller),
                              _buildProfileContent(context, controller, dark),
                            ],
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          gradient: APPColors.ceylonOceanGradient,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: APPColors.primary.withOpacity(0.4),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () => _showAddMediaOptions(context, controller),
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: const Icon(Iconsax.camera, color: APPColors.white),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, UserController controller) {
    return Container(
      padding: const EdgeInsets.all(APPSizes.defaultSpace),
      child: Column(
        children: [
          // Profile Picture with Ceylon styling
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: APPColors.white,
                    width: 4,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: GestureDetector(
                  onTap: () => _showProfilePictureOptions(context, controller),
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: APPColors.lightGrey,
                    backgroundImage: controller.user.value.profilePicture.isNotEmpty
                        ? NetworkImage(controller.user.value.profilePicture)
                        : null,
                    child: controller.user.value.profilePicture.isEmpty
                        ? const Icon(Iconsax.user, size: 60, color: APPColors.darkGrey)
                        : null,
                  ),
                ),
              ),
              Positioned(
                bottom: 5,
                right: 5,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: APPColors.ceylonSunriseGradient,
                    shape: BoxShape.circle,
                    border: Border.all(color: APPColors.white, width: 2),
                  ),
                  child: const Icon(
                    Iconsax.camera,
                    color: APPColors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: APPSizes.spaceBtwItems),

          // User Name
          Text(
            controller.user.value.fullName,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: APPColors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),

          const SizedBox(height: APPSizes.xs),

          // Username with Ceylon styling
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: APPColors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: APPColors.white.withOpacity(0.3)),
            ),
            child: Text(
              '@${controller.user.value.username}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: APPColors.white,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileContent(BuildContext context, UserController controller, bool dark) {
    return Container(
      margin: const EdgeInsets.only(top: APPSizes.spaceBtwSections),
      decoration: BoxDecoration(
        color: dark ? APPColors.dark : APPColors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(APPSizes.cardRadiusLg),
          topRight: Radius.circular(APPSizes.cardRadiusLg),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(APPSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: APPColors.grey,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            const SizedBox(height: APPSizes.spaceBtwSections),

            _buildUserInfo(controller, dark),
            const SizedBox(height: APPSizes.spaceBtwSections),
            _buildMediaGallery(context, controller, dark),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfo(UserController controller, bool dark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Iconsax.profile_circle,
              color: APPColors.primary,
              size: 24,
            ),
            const SizedBox(width: APPSizes.sm),
            Text(
              'Account Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: dark ? APPColors.white : APPColors.textPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: APPSizes.spaceBtwItems),
        Container(
          padding: const EdgeInsets.all(APPSizes.md),
          decoration: BoxDecoration(
            color: dark ? APPColors.darkContainer : APPColors.lightContainer,
            borderRadius: BorderRadius.circular(APPSizes.cardRadiusMd),
            border: Border.all(
              color: APPColors.primary.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              _ceylonInfoTile(Iconsax.sms, 'Email', controller.user.value.email, dark),
              if (controller.user.value.phoneNumber.isNotEmpty)
                _ceylonInfoTile(Iconsax.call, 'Phone', controller.user.value.formattedPhoneNo, dark),
              _ceylonInfoTile(Iconsax.calendar, 'Joined', _formatDate(controller.user.value.createdAt), dark),
              _ceylonInfoTile(Iconsax.refresh, 'Last Updated', _formatDate(controller.user.value.updatedAt), dark,
                  isLast: true),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMediaGallery(BuildContext context, UserController controller, bool dark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Iconsax.gallery,
              color: APPColors.primary,
              size: 24,
            ),
            const SizedBox(width: APPSizes.sm),
            Text(
              'My Travel Gallery',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: dark ? APPColors.white : APPColors.textPrimary,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: APPColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${controller.userMedia.length} photos',
                style: TextStyle(
                  color: APPColors.primary,
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: APPSizes.spaceBtwItems),
        controller.userMedia.isEmpty
            ? Container(
                padding: const EdgeInsets.all(APPSizes.xl),
                decoration: BoxDecoration(
                  color: dark ? APPColors.darkContainer : APPColors.lightContainer,
                  borderRadius: BorderRadius.circular(APPSizes.cardRadiusMd),
                  border: Border.all(
                    color: APPColors.primary.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      Iconsax.camera,
                      size: 64,
                      color: APPColors.primary.withOpacity(0.5),
                    ),
                    const SizedBox(height: APPSizes.md),
                    Text(
                      'No travel memories yet',
                      style: TextStyle(
                        color: dark ? APPColors.lightGrey : APPColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: APPSizes.xs),
                    Text(
                      'Start capturing your Ceylon adventures!',
                      style: TextStyle(
                        color: APPColors.textSecondary,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            : GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: controller.userMedia.length,
                itemBuilder: (context, index) {
                  final mediaUrl = controller.userMedia[index];
                  return GestureDetector(
                    onTap: () => _showMediaDetails(context, mediaUrl, controller),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(APPSizes.cardRadiusSm),
                        border: Border.all(
                          color: APPColors.primary.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(APPSizes.cardRadiusSm),
                        child: Image.network(
                          mediaUrl,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              color: APPColors.lightGrey,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: APPColors.primary,
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: APPColors.lightGrey,
                              child: Icon(
                                Iconsax.image,
                                color: APPColors.darkGrey,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
      ],
    );
  }

  Widget _ceylonInfoTile(IconData icon, String title, String value, bool dark, {bool isLast = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(
                bottom: BorderSide(
                  color: APPColors.primary.withOpacity(0.1),
                  width: 1,
                ),
              ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: APPColors.primary,
            size: 20,
          ),
          const SizedBox(width: APPSizes.sm),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: APPColors.textSecondary,
            ),
          ),
          const Spacer(),
          Flexible(
            child: Text(
              value,
              style: TextStyle(
                color: dark ? APPColors.white : APPColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showLogoutDialog(BuildContext context, UserController controller) {
    APPDialogs.confirmationDialog(
      title: 'Logout',
      message: 'Are you sure you want to logout from Ceylon 360?',
      confirmText: 'Logout',
      cancelText: 'Cancel',
      onConfirm: () async {
        // Implement logout functionality
        await AuthenticationRepository.instance.logout();
        Get.offAll(() => const LoginScreen()); // Navigate to login screen
      },
    );
  }

  void _showProfilePictureOptions(BuildContext context, UserController controller) {
    APPDialogs.mediaSelectionDialog(
      onCamera: () => _pickProfilePicture(ImageSource.camera, controller),
      onGallery: () => _pickProfilePicture(ImageSource.gallery, controller),
    );
  }

  void _showAddMediaOptions(BuildContext context, UserController controller) {
    APPDialogs.mediaSelectionDialog(
      onCamera: () => _pickMedia(ImageSource.camera, controller),
      onGallery: () => _pickMedia(ImageSource.gallery, controller),
    );
  }

  Future<void> _pickProfilePicture(ImageSource source, UserController controller) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        imageQuality: 70,
      );

      if (image != null) {
        await controller.uploadProfilePicture(File(image.path));
      }
    } catch (e) {
      APPLoaders.errorSnackBar(
        title: 'Error',
        message: 'Failed to pick image: $e',
      );
    }
  }

  Future<void> _pickMedia(ImageSource source, UserController controller) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        imageQuality: 70,
      );

      if (image != null) {
        final metadata = {
          'timestamp': DateTime.now().millisecondsSinceEpoch,
          'type': 'image',
          'source': source.toString(),
        };

        await controller.addUserMedia(File(image.path), metadata: metadata);
      }
    } catch (e) {
      APPLoaders.errorSnackBar(
        title: 'Error',
        message: 'Failed to pick image: $e',
      );
    }
  }

  void _showMediaDetails(BuildContext context, String mediaUrl, UserController controller) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final dark = APPHelperFunctions.isDarkMode(context);
        return Container(
          decoration: BoxDecoration(
            color: dark ? APPColors.dark : APPColors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(APPSizes.cardRadiusLg)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(APPSizes.defaultSpace),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Drag Handle
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: APPColors.grey,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                const SizedBox(height: APPSizes.spaceBtwItems),

                ClipRRect(
                  borderRadius: BorderRadius.circular(APPSizes.cardRadiusMd),
                  child: Image.network(
                    mediaUrl,
                    height: 200,
                    fit: BoxFit.contain,
                  ),
                ),

                const SizedBox(height: APPSizes.spaceBtwItems),

                Text(
                  'Captured on: ${_formatDate(DateTime.now())}',
                  style: TextStyle(
                    color: APPColors.textSecondary,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: APPSizes.spaceBtwSections),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _ceylonActionButton(
                      icon: Iconsax.share,
                      label: 'Share',
                      color: APPColors.primary,
                      onTap: () => Navigator.pop(context),
                    ),
                    _ceylonActionButton(
                      icon: Iconsax.document_download,
                      label: 'Download',
                      color: APPColors.ceylonTeal,
                      onTap: () => Navigator.pop(context),
                    ),
                    _ceylonActionButton(
                      icon: Iconsax.trash,
                      label: 'Delete',
                      color: APPColors.error,
                      onTap: () {
                        Navigator.pop(context);
                        _confirmDeleteMedia(context, mediaUrl, controller);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _ceylonActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(
                color: color.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: APPSizes.xs),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteMedia(BuildContext context, String mediaUrl, UserController controller) {
    APPDialogs.confirmationDialog(
      title: 'Delete Photo',
      message: 'Are you sure you want to delete this travel memory? This action cannot be undone.',
      confirmText: 'Delete',
      onConfirm: () async {
        await controller.removeUserMedia(mediaUrl);
      },
    );
  }
}
