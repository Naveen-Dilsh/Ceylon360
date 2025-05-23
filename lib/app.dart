import 'package:ceyloan_360/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'bindings/general_bindings.dart';
import 'utils/constants/colors.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      themeMode: ThemeMode.system,
      theme: CAppTheme.lightTheme,
      darkTheme: CAppTheme.darkTheme,
      initialBinding: GeneralBindings(),
      // home: const OnboardingScreen(),
      home: const Scaffold(
          backgroundColor: APPColors.primary, body: Center(child: CircularProgressIndicator(color: Colors.white))),
    );
  }
}
