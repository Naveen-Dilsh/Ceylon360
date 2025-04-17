import 'package:ceyloan_360/features/authentication/screens/signup/widgets/terms_condition_checkbox.dart';
import 'package:flutter/material.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/helpers/helper_functions.dart';

class APPSignUpForm extends StatelessWidget {
  const APPSignUpForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dark = APPHelperFunctions.isDarkMode(context);
    return Form(
      child: Column(
        children: [
          // First & Last Name
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  expands: false,
                  decoration: const InputDecoration(
                    labelText: "First Name",
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                ),
              ),
              const SizedBox(width: APPSizes.spaceBtwInputFields),
              Expanded(
                child: TextFormField(
                  expands: false,
                  decoration: const InputDecoration(
                    labelText: "Last Name",
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: APPSizes.spaceBtwInputFields),

          // Username
          TextFormField(
            expands: false,
            decoration: const InputDecoration(
              labelText: "Username",
              prefixIcon: Icon(Icons.person_outline_outlined),
            ),
          ),
          const SizedBox(height: APPSizes.spaceBtwInputFields),

          // Email
          TextFormField(
            expands: false,
            decoration: const InputDecoration(
              labelText: "Email",
              prefixIcon: Icon(Icons.email_outlined),
            ),
          ),
          const SizedBox(height: APPSizes.spaceBtwInputFields),

          // Phone Number
          TextFormField(
            expands: false,
            decoration: const InputDecoration(
              labelText: "Phone",
              prefixIcon: Icon(Icons.call_outlined),
            ),
          ),
          const SizedBox(height: APPSizes.spaceBtwInputFields),

          // Password
          TextFormField(
            obscureText: true,
            decoration: const InputDecoration(
              labelText: "Password",
              prefixIcon: Icon(Icons.password_outlined),
              suffixIcon: Icon(Icons.visibility_outlined),
            ),
          ),
          const SizedBox(height: APPSizes.spaceBtwInputFields),

          // Terms & Conditions Checkbox
          const APPTermsAndConditionCheckbox(),
          const SizedBox(height: APPSizes.spaceBtwSections),

          // Sign Up Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              child: const Text("Create Account"),
            ),
          ),
        ],
      ),
    );
  }
}
