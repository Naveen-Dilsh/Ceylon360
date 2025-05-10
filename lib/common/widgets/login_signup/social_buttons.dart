import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../features/authentication/controllers/login/login_controller.dart';
import '../../../utils/constants/colors.dart';
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

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Google Button
            _buildSocialButton(
              context: context,
              isDark: isDark,
              iconPath: APPImages.google,
              onPressed: () => controller.googleSignIn(),
              backgroundColor: isDark ? Colors.transparent : APPColors.white,
              borderColor: APPColors.primary.withOpacity(0.5),
            ),

            const SizedBox(width: APPSizes.spaceBtwItems),

            // Facebook Button
            _buildSocialButton(
              context: context,
              isDark: isDark,
              iconPath: APPImages.facebook,
              onPressed: () {},
              backgroundColor: isDark ? Colors.transparent : APPColors.white,
              borderColor: APPColors.primary.withOpacity(0.5),
            ),
          ],
        ),

        // Promotional text for tourism
        Container(
          margin: const EdgeInsets.only(top: APPSizes.spaceBtwItems),
          padding: const EdgeInsets.symmetric(horizontal: APPSizes.md, vertical: APPSizes.sm),
          decoration: BoxDecoration(
            color: APPColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: APPColors.primary.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.travel_explore,
                color: APPColors.primary,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                "Join 10,000+ travelers exploring Sri Lanka",
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isDark ? APPColors.textWhite.withOpacity(0.7) : APPColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    required BuildContext context,
    required bool isDark,
    required String iconPath,
    required VoidCallback onPressed,
    required Color backgroundColor,
    required Color borderColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(100),
        border: Border.all(
          color: borderColor,
          width: 1.5,
        ),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: APPColors.dark.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(100),
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Image(
              width: APPSizes.iconMd,
              height: APPSizes.iconMd,
              image: AssetImage(iconPath),
            ),
          ),
        ),
      ),
    );
  }
}
