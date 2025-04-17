import 'package:ceyloan_360/features/authentication/screens/signup/widgets/signup_form.dart';
import 'package:flutter/material.dart';
import '../../../../common/widgets/login_signup/form_divider.dart';
import '../../../../common/widgets/login_signup/social_buttons.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/helpers/helper_functions.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = APPHelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
          child: Padding(
        padding: EdgeInsets.all(APPSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              "Signup to your account",
              style: Theme.of(context).textTheme.headlineMedium,
            ),

            const SizedBox(height: APPSizes.defaultSpace),

            // Form
            const APPSignUpForm(),
            const SizedBox(height: APPSizes.spaceBtwSections),

            // Divider
            TFormDivider(dividerText: "Or Signup With"),

            const SizedBox(height: APPSizes.spaceBtwSections),
            // Social Buttons
            const TSocialButtons(),
          ],
        ),
      )),
    );
  }
}
