import 'package:ceyloan_360/utils/constants/sizes.dart';
import 'package:ceyloan_360/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({
    super.key,
    required this.image,
    required this.title,
    required this.subTitle,
  });

  final String image, title, subTitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(APPSizes.defaultSpace),
      child: Column(
        children: [
          Image(
            width: APPHelperFunctions.screenWidth() * 0.8,
            height: APPHelperFunctions.screenHeight() * 0.6,
            image: AssetImage(image),
          ),
          Text(title, style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center),
          Text(subTitle, style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center),
          // Column continues...
        ],
      ),
    );
  }
}
