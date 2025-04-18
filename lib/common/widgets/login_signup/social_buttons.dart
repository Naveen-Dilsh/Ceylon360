import 'package:flutter/material.dart';
import '../../../utils/constants/image_strings.dart';
import '../../../utils/constants/sizes.dart';

class TSocialButtons extends StatelessWidget {
  const TSocialButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
            onPressed: () {},
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
