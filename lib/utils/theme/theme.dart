import 'package:ceyloan_360/utils/theme/custome_themes/checkbox_theme.dart';
import 'package:ceyloan_360/utils/theme/custome_themes/chip_theme.dart';
import 'package:ceyloan_360/utils/theme/custome_themes/elevated_button_theme.dart';
import 'package:ceyloan_360/utils/theme/custome_themes/text_field_theme.dart';
import 'package:ceyloan_360/utils/theme/custome_themes/text_theme.dart';
import 'package:flutter/material.dart';

class CAppTheme {
  CAppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: "Poppins",
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: Colors.white,
    textTheme: APPTextTheme.lightTextTheme,
    elevatedButtonTheme: APPElevatedButtonTheme.lightElevatedButtonTheme,
    chipTheme: APPChipTheme.lightChipTheme,
    // appBarTheme: TAppBarTheme.lightAppBarTheme,
    checkboxTheme: APPCheckboxTheme.lightCheckboxTheme,
    // bottomSheetTheme: TBottomSheetTheme.lightBottomSheetTheme,
    // outlinedButtonTheme: TOutlinedButtonTheme.lightOutlinedButtonTheme,
    inputDecorationTheme: APPTextFormFieldTheme.lightInputDecorationTheme,
  );

  static ThemeData darkTheme = ThemeData(
      useMaterial3: true,
      fontFamily: "Poppins",
      brightness: Brightness.dark,
      primaryColor: Colors.blue,
      scaffoldBackgroundColor: Colors.black,
      textTheme: APPTextTheme.darkTextTheme,
      elevatedButtonTheme: APPElevatedButtonTheme.darkElevatedButtonTheme);
}
