import 'package:flutter/material.dart';
import 'package:ceyloan_360/utils/constants/colors.dart';
import 'package:ceyloan_360/utils/constants/sizes.dart';
import 'package:ceyloan_360/utils/constants/image_strings.dart';
import 'package:ceyloan_360/utils/helpers/helper_functions.dart';

class ProfessionalOnBoardingPage extends StatelessWidget {
  const ProfessionalOnBoardingPage({
    super.key,
    required this.backgroundImage,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.overlayColor,
  });

  final String backgroundImage, title, subtitle, description;
  final Color overlayColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(backgroundImage),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color.fromARGB(0, 0, 0, 0).withOpacity(0.3),
              overlayColor.withOpacity(0.2),
              Colors.black.withOpacity(0.9),
            ],
            stops: const [0.0, 0.6, 1.0],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 32),

                // App Logo - Circular Design
                Center(
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                      border: Border.all(
                        color: APPColors.primary.withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(1),
                      child: Image.asset(
                        APPImages.lightAppLogo, // Your app logo asset
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // App Name/Brand
                // Center(
                //   child: Text(
                //     "ආයුබෝවන්!",
                //     style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                //           fontWeight: FontWeight.bold,
                //           color: Colors.white,
                //         ),
                //   ),
                // ),

                const Spacer(flex: 3),

                // Main Title
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    height: 1.1,
                    letterSpacing: -1.5,
                  ),
                ),

                const SizedBox(height: 16),

                // Subtitle
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: APPColors.ceylonYellow,
                    letterSpacing: 0.5,
                  ),
                ),

                const SizedBox(height: 24),

                // Description
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                    height: 1.6,
                    letterSpacing: 0.2,
                  ),
                ),

                const Spacer(flex: 2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
