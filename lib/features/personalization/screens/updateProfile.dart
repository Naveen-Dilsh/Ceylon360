import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/helpers/helper_functions.dart';
import '../controllers/user_controller.dart';

class UpdateProfileScreen extends StatelessWidget {
  const UpdateProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UserController>();
    final dark = APPHelperFunctions.isDarkMode(context);

    final firstNameController = TextEditingController(text: controller.user.value.firstName);
    final lastNameController = TextEditingController(text: controller.user.value.lastName);
    final usernameController = TextEditingController(text: controller.user.value.username);
    final phoneController = TextEditingController(text: controller.user.value.phoneNumber);

    final formKey = GlobalKey<FormState>();

    return Scaffold(
      backgroundColor: dark ? APPColors.dark : APPColors.light,
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: APPColors.primary,
        foregroundColor: APPColors.white,
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator(color: APPColors.primary))
            : SingleChildScrollView(
                padding: const EdgeInsets.all(APPSizes.defaultSpace),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(APPSizes.md),
                        decoration: BoxDecoration(
                          color: dark ? APPColors.darkContainer : APPColors.white,
                          borderRadius: BorderRadius.circular(APPSizes.cardRadiusMd),
                          border: Border.all(
                            color: APPColors.primary.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Iconsax.edit,
                                  color: APPColors.primary,
                                  size: 24,
                                ),
                                const SizedBox(width: APPSizes.sm),
                                Text(
                                  'Personal Information',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: dark ? APPColors.white : APPColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: APPSizes.spaceBtwItems),
                            TextFormField(
                              controller: firstNameController,
                              decoration: InputDecoration(
                                labelText: 'First Name',
                                prefixIcon: Icon(Iconsax.user, color: APPColors.primary),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(APPSizes.inputFieldRadius),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(APPSizes.inputFieldRadius),
                                  borderSide: BorderSide(color: APPColors.primary, width: 2),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your first name';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: APPSizes.spaceBtwInputFields),
                            TextFormField(
                              controller: lastNameController,
                              decoration: InputDecoration(
                                labelText: 'Last Name',
                                prefixIcon: Icon(Iconsax.user, color: APPColors.primary),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(APPSizes.inputFieldRadius),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(APPSizes.inputFieldRadius),
                                  borderSide: BorderSide(color: APPColors.primary, width: 2),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your last name';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: APPSizes.spaceBtwInputFields),
                            TextFormField(
                              controller: usernameController,
                              decoration: InputDecoration(
                                labelText: 'Username',
                                prefixIcon: Icon(Iconsax.user_tag, color: APPColors.primary),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(APPSizes.inputFieldRadius),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(APPSizes.inputFieldRadius),
                                  borderSide: BorderSide(color: APPColors.primary, width: 2),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a username';
                                }
                                if (value.length < 4) {
                                  return 'Username must be at least 4 characters long';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: APPSizes.spaceBtwInputFields),
                            TextFormField(
                              controller: phoneController,
                              decoration: InputDecoration(
                                labelText: 'Phone Number',
                                prefixIcon: Icon(Iconsax.call, color: APPColors.primary),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(APPSizes.inputFieldRadius),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(APPSizes.inputFieldRadius),
                                  borderSide: BorderSide(color: APPColors.primary, width: 2),
                                ),
                              ),
                              keyboardType: TextInputType.phone,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: APPSizes.spaceBtwSections),
                      SizedBox(
                        width: double.infinity,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: APPColors.ceylonOceanGradient,
                            borderRadius: BorderRadius.circular(APPSizes.buttonRadius),
                            boxShadow: [
                              BoxShadow(
                                color: APPColors.primary.withOpacity(0.4),
                                blurRadius: 15,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                controller.updateUserData(
                                  firstName: firstNameController.text,
                                  lastName: lastNameController.text,
                                  username: usernameController.text,
                                  phoneNumber: phoneController.text,
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              padding: const EdgeInsets.symmetric(vertical: APPSizes.buttonHeight),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(APPSizes.buttonRadius),
                              ),
                            ),
                            child: const Text(
                              'Save Changes',
                              style: TextStyle(
                                color: APPColors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
