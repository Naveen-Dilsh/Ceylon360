import 'package:flutter/material.dart';
import '../../../utils/constants/colors.dart';

class TFormDivider extends StatelessWidget {
  const TFormDivider({
    super.key,
    required this.dark,
  });

  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Divider(
            color: dark ? APPColors.darkGrey : APPColors.grey,
            thickness: 0.5,
            indent: 60,
            endIndent: 5,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: dark ? Colors.black12 : Colors.white.withOpacity(0.8),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: dark ? APPColors.darkGrey : APPColors.primary.withOpacity(0.5),
              width: 0.5,
            ),
          ),
          child: Text(
            "or sign in with",
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: dark ? Colors.white70 : APPColors.primary,
                ),
          ),
        ),
        Flexible(
          child: Divider(
            color: dark ? APPColors.darkGrey : APPColors.grey,
            thickness: 0.5,
            indent: 5,
            endIndent: 60,
          ),
        ),
      ],
    );
  }
}
