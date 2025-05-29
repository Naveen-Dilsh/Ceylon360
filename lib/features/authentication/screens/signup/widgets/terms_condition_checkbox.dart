import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/helpers/helper_functions.dart';
import '../../../controllers/signup/signup_controller.dart';

class APPTermsAndConditionCheckbox extends StatelessWidget {
  const APPTermsAndConditionCheckbox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = SignupController.instance;
    final dark = APPHelperFunctions.isDarkMode(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: APPSizes.sm,
        horizontal: APPSizes.sm,
      ),
      decoration: BoxDecoration(
        color: dark ? APPColors.darkContainer.withOpacity(0.5) : APPColors.ceylonSand.withOpacity(0.3),
        borderRadius: BorderRadius.circular(APPSizes.inputFieldRadius),
        border: Border.all(
          color: dark ? APPColors.borderSecondary.withOpacity(0.3) : APPColors.borderSecondary,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Custom Checkbox
          Obx(() => InkWell(
              onTap: () => controller.privacyPolicy.value = !controller.privacyPolicy.value,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: controller.privacyPolicy.value ? APPColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: controller.privacyPolicy.value
                        ? APPColors.primary
                        : dark
                            ? APPColors.borderSecondary
                            : APPColors.primary.withOpacity(0.5),
                    width: 1.5,
                  ),
                ),
                child: controller.privacyPolicy.value
                    ? const Icon(
                        Icons.check,
                        size: 16,
                        color: APPColors.white,
                      )
                    : null,
              ))),
          const SizedBox(width: APPSizes.sm),

          // Text Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 2.0),
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'I agree to the ',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: dark ? APPColors.lightGrey : APPColors.textSecondary,
                          ),
                    ),
                    TextSpan(
                      text: "Privacy Policy",
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: dark ? APPColors.ceylonYellow : APPColors.primary,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                    ),
                    TextSpan(
                      text: ' and ',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: dark ? APPColors.lightGrey : APPColors.textSecondary,
                          ),
                    ),
                    TextSpan(
                      text: "Terms of Use",
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: dark ? APPColors.ceylonYellow : APPColors.primary,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                    ),
                    TextSpan(
                      text: ' of Ceylon 360',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: dark ? APPColors.lightGrey : APPColors.textSecondary,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
