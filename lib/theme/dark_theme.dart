import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hqs_desktop/theme/constants.dart';
import 'package:hqs_desktop/theme/theme.dart';

class DarkTheme implements HqsTheme {
  @override
  Color cardDefaultColor() {
    return darkThemeCardColor;
  }

  @override
  Color defaultBackgroundColor() {
    return Color(int.parse("0xff121212"));
  }

  @override
  Color titleColor() {
    return darkThemeTextColor;
  }

  @override
  Color cardLoginColor() {
    // TODO: implement cardLoginColor
    throw UnimplementedError();
  }

  @override
  Color cardLoginTitleColor() {
    // TODO: implement cardLoginTitleColor
    throw UnimplementedError();
  }

  @override
  List<Color> defaultGradientColor() {
    return [
      Color(int.parse("0xff1e39ff")),
      Color(int.parse("0xff206aff")),
      Color(int.parse("0xff22b0ff")),
    ];
  }

  @override
  Color loginBackgroundColor() {
    return Color(int.parse("0xff172b4d"));
  }

  @override
  Color welcomeLoginColor() {
    return Colors.white;
  }

  @override
  Color primaryColor() {
    return Color(int.parse("0xff2062ff"));
  }

  @override
  Color buttonTextColor() {
    return Colors.white;
  }

  @override
  Color flushBackgroundColor() {
    return Colors.blueGrey[500].withAlpha(200);
  }

  @override
  Color dangerColor() {
    return Colors.red;
  }

  @override
  Color appbarColor() {
    return Color(int.parse("0xff16213e"));
  }

  @override
  Color successColor() {
    return Colors.green[500];
  }

  @override
  Color defaultColor() {
    return Color(int.parse("0xff0f3460"));
  }

  @override
  Color infoColor() {
    return Colors.amber[300];
  }

  @override
  Color formBorderColor() {
    return Colors.grey[700];
  }

  @override
  Color textColor() {
    return Colors.grey[200];
  }

  @override
  Color loginCardColor() {
    return Colors.white;
  }

  @override
  Color hintColor() {
    return Color(int.parse("0xff1f4068"));
  }

  @override
  Color dividerColor() {
    return Colors.grey[700];
  }

  @override
  Color iconColor() {
    return Colors.grey;
  }
}
