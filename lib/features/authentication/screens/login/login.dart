import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../../common/styles/spacing_styles.dart';
import '../../../../common/widgets/login_signup/form_divider.dart';
import '../../../../common/widgets/login_signup/social_buttons.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/helpers/helper_functions.dart';
import 'widgets/login_form.dart';
import 'widgets/login_header.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = APPHelperFunctions.isDarkMode(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.1),
              Theme.of(context).scaffoldBackgroundColor,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: APPSpacingStyle.paddingWithAppBarHeight,
              child: Column(
                children: [
                  // Logo, Title & Sub-Title
                  const TLoginHeader(),

                  // Form
                  Container(
                    margin: const EdgeInsets.only(top: APPSizes.spaceBtwSections),
                    padding: const EdgeInsets.all(APPSizes.md),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(APPSizes.cardRadiusLg),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: const APPLoginForm(),
                  ),

                  const SizedBox(height: APPSizes.spaceBtwSections),

                  // Divider
                  TFormDivider(dividerText: "Or Sign In With"),

                  const SizedBox(height: APPSizes.spaceBtwSections),

                  // Footer
                  const TSocialButtons(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
