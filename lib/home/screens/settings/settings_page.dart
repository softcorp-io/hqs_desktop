import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hqs_desktop/constants/constants.dart';
import 'package:hqs_desktop/home/screens/profile/constants/constants.dart';
import 'package:hqs_desktop/home/screens/profile/constants/text.dart';
import 'package:hqs_desktop/service/hqs_user_service.dart';
import 'package:hqs_desktop/theme/constants.dart';
import 'package:hqs_desktop/theme/theme.dart';

class SettingsPage extends StatefulWidget {
  final HqsService service;
  final HqsTheme theme;
  final lightTheme;
  final Function changeTheme;
  bool lightThemeCheckbox;
  bool darkThemeCheckBox;
  SettingsPage(
      {@required this.service,
      @required this.theme,
      @required this.lightTheme,
      @required this.changeTheme})
      : assert(service != null),
        assert(theme != null),
        assert(lightTheme != null) {}

  @override
  _SettingsPageState createState() => _SettingsPageState(
      service: service,
      theme: theme,
      lightTheme: lightTheme,
      changeTheme: changeTheme);
}

/// This is the stateless widget that the main application instantiates.
class _SettingsPageState extends State<SettingsPage> {
  final HqsService service;
  final HqsTheme theme;
  final lightTheme;
  final Function changeTheme;
  bool lightThemeCheckbox;
  bool darkThemeCheckBox;
  _SettingsPageState(
      {@required this.service,
      @required this.theme,
      @required this.lightTheme,
      @required this.changeTheme})
      : assert(service != null),
        assert(theme != null),
        assert(lightTheme != null) {
    lightThemeCheckbox = lightTheme;
    darkThemeCheckBox = !lightTheme;
  }

  @override
  @override
  Widget build(BuildContext context) {
    EdgeInsets edgeInsets = EdgeInsets.all(cardPadding);
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Padding(
          padding: edgeInsets,
          child: Card(
            elevation: 4,
            color: theme.cardDefaultColor(),
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(cardBorderRadius),
              ),
            ),
            child: SingleChildScrollView(
              child: Container(
                width: size.width,
                child: Padding(
                  padding: EdgeInsets.all(40),
                  child: Column(
                    children: [
                      Align(
                        child: Text(
                          "Theme Settings",
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: theme.titleColor(),
                          ),
                        ),
                        alignment: Alignment.topLeft,
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        direction: Axis.horizontal,
                        children: [
                          Column(children: [
                            Text(
                              "Light Theme",
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: theme.titleColor(),
                              ),
                            ),
                            Container(
                              color: Colors.transparent,
                              height: 150,
                              width: 250,
                              child: Card(
                                child: Center(
                                  child: Text(
                                    "Text In Light Theme",
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: lightThemeTextColor,
                                    ),
                                  ),
                                ),
                                elevation: 5,
                                color: lightThemeCardColor,
                              ),
                            ),
                            Checkbox(
                                value: lightThemeCheckbox,
                                onChanged: (value) {
                                  changeTheme(value);
                                  setState(() {
                                    lightThemeCheckbox = value;
                                    darkThemeCheckBox = !value;
                                  });
                                })
                          ]),
                          SizedBox(
                            width: 50,
                          ),
                          Column(children: [
                            Text(
                              "Dark Theme",
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: theme.titleColor(),
                              ),
                            ),
                            Container(
                              color: Colors.transparent,
                              height: 150,
                              width: 250,
                              child: Card(
                                child: Center(
                                  child: Text(
                                    "Text In Dark Theme",
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: darkThemeTextColor,
                                    ),
                                  ),
                                ),
                                elevation: 5,
                                color: darkThemeCardColor,
                              ),
                            ),
                            Checkbox(
                                value: darkThemeCheckBox,
                                onChanged: (value) {
                                  changeTheme(value);
                                  setState(() {
                                    lightThemeCheckbox = !value;
                                    darkThemeCheckBox = value;
                                  });
                                })
                          ]),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
