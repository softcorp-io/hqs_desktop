import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hqs_desktop/theme/constants.dart';

class HqsDarkTheme {
  ThemeData getTheme() {
    TextTheme textTheme = GoogleFonts.poppinsTextTheme().apply(
        bodyColor: ThemeData.dark().textTheme.bodyText1.color,
        displayColor: ThemeData.dark().textTheme.headline1.color);
    return ThemeData.dark().copyWith(
      textTheme: textTheme,
      accentColor: primaryColor,
      appBarTheme: AppBarTheme(color: primaryColor),
      primaryColor: primaryColor,
      inputDecorationTheme: InputDecorationTheme(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: primaryColor, width: 1.0),
          ),
          labelStyle: TextStyle(color: ThemeData.dark().iconTheme.color),
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
