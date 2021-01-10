import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hqs_desktop/constants/constants.dart';
import 'package:hqs_desktop/home/screens/profile/constants/constants.dart';
import 'package:hqs_desktop/theme/hqs_dark_theme.dart';
import 'package:hqs_desktop/theme/hqs_light_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum HqsTheme { dark, light }

class SettingsPage extends StatefulWidget {
  final Function changeTheme;
  SettingsPage({@required this.changeTheme}) : assert(changeTheme != null);
  @override
  _SettingsPageState createState() => _SettingsPageState(changeTheme: changeTheme);
}

class _SettingsPageState extends State<SettingsPage> {
  final Function changeTheme;
  final ThemeData lightTheme = HqsLightTheme().getTheme();
  final ThemeData darkTheme = HqsDarkTheme().getTheme();
  SharedPreferences prefs;
  Future<void> getStoredTheme;
  HqsTheme chosenTheme = HqsTheme.light;

  void setTheme(HqsTheme theme) {
    switch (theme) {
      case HqsTheme.dark:
        if (chosenTheme != HqsTheme.dark) {
          setState(() {
            print("get in here dark");
            chosenTheme = HqsTheme.dark;
            changeTheme(HqsTheme.dark);
            prefs.setString('theme', 'dark');
          });
        }
        break;
      case HqsTheme.light:
        if (chosenTheme != HqsTheme.light) {
          setState(() {
            print("get in here light");
            chosenTheme = HqsTheme.light;
            changeTheme(HqsTheme.light);
            prefs.setString('theme', 'light');
          });
        }
        break;
    }
  }

  _SettingsPageState({@required this.changeTheme}) {
    getStoredTheme = getThemeStored();
  }

  Future<void> getThemeStored() async {
    prefs = await SharedPreferences.getInstance();
    String currentTheme = prefs.getString('theme');
    if (currentTheme == null) {
      throw Error();
    } else {
      switch (currentTheme) {
        case 'light':
          chosenTheme = HqsTheme.light;
          print("light");
          break;
        case 'dark':
          chosenTheme = HqsTheme.dark;
          print("dark");
          break;
        default:
          throw Error();
      }
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    EdgeInsets edgeInsets = EdgeInsets.all(cardPadding);
    Size size = MediaQuery.of(context).size;
    return FutureBuilder<void>(
        future: getStoredTheme,
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return Stack(
                children: [
                  Padding(
                    padding: edgeInsets,
                    child: Card(
                      elevation: 4,
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
                                                color: lightTheme
                                                    .textTheme.headline1.color,
                                              ),
                                            ),
                                          ),
                                          elevation: 5,
                                          color: lightTheme
                                              .scaffoldBackgroundColor,
                                        ),
                                      ),
                                      Checkbox(
                                          value: chosenTheme == HqsTheme.light,
                                          activeColor:
                                              Theme.of(context).primaryColor,
                                          onChanged: (value) {
                                            setTheme(HqsTheme.light);
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
                                                color: darkTheme
                                                    .textTheme.headline1.color,
                                              ),
                                            ),
                                          ),
                                          elevation: 6,
                                          color:
                                              darkTheme.scaffoldBackgroundColor,
                                        ),
                                      ),
                                      Checkbox(
                                          activeColor:
                                              Theme.of(context).primaryColor,
                                          value: chosenTheme == HqsTheme.dark,
                                          onChanged: (value) {
                                            setTheme(HqsTheme.dark);
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
            default:
              return Align(
                  child: Container(
                    child: CircularProgressIndicator(),
                  ),
                  alignment: Alignment.center);
          }
        });
  }
}
