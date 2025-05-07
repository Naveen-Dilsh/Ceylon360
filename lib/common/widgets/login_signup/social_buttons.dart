import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../features/authentication/controllers/login/login_controller.dart';
import '../../../utils/constants/image_strings.dart';
import '../../../utils/constants/sizes.dart';

class APPSocialButtons extends StatelessWidget {
  const APPSocialButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final controller = Get.put(LoginController());
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Google Button
        Container(
          decoration: BoxDecoration(
            color: isDark ? Colors.transparent : Colors.white,
            border: Border.all(
              color: Colors.grey.withOpacity(0.4),
            ),
            borderRadius: BorderRadius.circular(100),
            boxShadow: [
              if (!isDark)
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
            ],
          ),
          child: IconButton(
            onPressed: () => controller.googleSignIn(),
            padding: const EdgeInsets.all(12),
            icon: const Image(
              width: APPSizes.iconMd,
              height: APPSizes.iconMd,
              image: AssetImage(APPImages.google),
            ),
          ),
        ),

        const SizedBox(width: APPSizes.spaceBtwItems),

        // Facebook Button
        Container(
          decoration: BoxDecoration(
            color: isDark ? Colors.transparent : Colors.white,
            border: Border.all(
              color: Colors.grey.withOpacity(0.4),
            ),
            borderRadius: BorderRadius.circular(100),
            boxShadow: [
              if (!isDark)
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
            ],
          ),
          child: IconButton(
            onPressed: () {},
            padding: const EdgeInsets.all(12),
            icon: const Image(
              width: APPSizes.iconMd,
              height: APPSizes.iconMd,
              image: AssetImage(APPImages.facebook),
            ),
          ),
        ),
      ],
    );
  }
}
