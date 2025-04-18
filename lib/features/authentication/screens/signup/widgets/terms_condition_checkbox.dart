import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
    return Row(
      children: [
        SizedBox(
            width: 24,
            height: 24,
            child: Obx(() => Checkbox(
                value: controller.privacyPolicy.value,
                onChanged: (value) => controller.privacyPolicy.value = !controller.privacyPolicy.value))),
        const SizedBox(width: APPSizes.spaceBtwItems),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(text: 'I Agree to ', style: Theme.of(context).textTheme.bodySmall),
              TextSpan(
                text: "Privacy Policy",
                style: Theme.of(context).textTheme.bodyMedium!.apply(
                      color: dark ? APPColors.white : APPColors.primary,
                      decoration: TextDecoration.underline,
                      decorationColor: dark ? APPColors.white : APPColors.primary,
                    ),
              ),
              TextSpan(text: ' And ', style: Theme.of(context).textTheme.bodySmall),
              TextSpan(
                text: "Term Of Use",
                style: Theme.of(context).textTheme.bodyMedium!.apply(
                      color: dark ? APPColors.white : APPColors.primary,
                      decoration: TextDecoration.underline,
                      decorationColor: dark ? APPColors.white : APPColors.primary,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
