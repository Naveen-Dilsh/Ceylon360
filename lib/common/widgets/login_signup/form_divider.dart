import 'package:flutter/material.dart';
import '../../../utils/helpers/helper_functions.dart';
import '../../../utils/constants/colors.dart';

class TFormDivider extends StatelessWidget {
  const TFormDivider({
    super.key,
    required this.dividerText,
  });

  final String dividerText;

  @override
  Widget build(BuildContext context) {
    final dark = APPHelperFunctions.isDarkMode(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Container(
            height: 1.5,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  dark ? APPColors.darkGrey : APPColors.primary.withOpacity(0.5),
                ],
              ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            gradient: dark
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [APPColors.dark.withOpacity(0.2), APPColors.dark.withOpacity(0.2)],
                  )
                : APPColors.ceylonOceanGradient.scale(0.1),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: dark ? APPColors.darkGrey : APPColors.primary.withOpacity(0.5),
              width: 1,
            ),
          ),
          child: Text(
            dividerText,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: dark ? APPColors.textWhite.withOpacity(0.7) : APPColors.primary,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
        Flexible(
          child: Container(
            height: 1.5,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  dark ? APPColors.darkGrey : APPColors.primary.withOpacity(0.5),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
