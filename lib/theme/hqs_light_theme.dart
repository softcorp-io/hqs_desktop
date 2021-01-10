import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hqs_desktop/theme/constants.dart';

class HqsLightTheme {
  ThemeData getTheme() {
    TextTheme textTheme = GoogleFonts.poppinsTextTheme().apply(
        bodyColor: ThemeData.light().textTheme.bodyText1.color,
        displayColor: ThemeData.light().textTheme.headline1.color);
    return ThemeData.light().copyWith(
      textTheme: textTheme,
      appBarTheme: AppBarTheme(color: ThemeData.light().cardColor),
      buttonTheme: ThemeData.light().buttonTheme.copyWith(
        textTheme: ButtonTextTheme.primary
      ),
      primaryColor: primaryColor,
      inputDecorationTheme: InputDecorationTheme(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: primaryColor, width: 1.0),
          ),
          labelStyle: TextStyle(color: ThemeData.light().iconTheme.color),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: darkBorderColor, width: 1.0),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: dangerColor, width: 1.0),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: dangerColor, width: 1.0),
          ),
          errorStyle: TextStyle(color: dangerColor),
          focusColor: primaryColor),
    );
  }
}
