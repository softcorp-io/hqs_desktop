import 'package:flutter/material.dart';
import 'package:hqs_desktop/service/hqs_user_service.dart';
import 'package:desktop_window/desktop_window.dart';
import 'dart:io';
import 'package:hqs_desktop/auth/auth_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hqs_desktop/constants/constants.dart';
import 'package:hqs_desktop/home/home.dart';
import 'package:hqs_desktop/theme/dark_theme.dart';
import 'package:hqs_desktop/theme/light_theme.dart';
import 'package:hqs_desktop/theme/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    DesktopWindow.setWindowSize(Size(800, 900));
    DesktopWindow.setMinWindowSize(Size(800, 900));
  }
  runApp(HqsApp());
}

class HqsApp extends StatefulWidget {
  @override
  _HqsAppState createState() => _HqsAppState();
}

class _HqsAppState extends State<HqsApp> {
  AuthStatus authStatus = AuthStatus.LoggedOut;
  onLogin() => setState(() {
        authStatus = AuthStatus.LoggedIn;
      });

  onLogout() => setState(() {
        authStatus = AuthStatus.LoggedOut;
      });

  HqsService service;
  Future<void> connected;

  _HqsAppState() {
    service = new HqsService(
        addr: "34.77.45.46", port: 9000, onLogin: onLogin, onLogout: onLogout);
    connected = service.connect();
  }

  HqsTheme theme;
  ThemeData getTheme(bool light) {
    ThemeData themeData;
    if (light) {
      theme = LightTheme();
      themeData = ThemeData.light();
    } else {
      theme = DarkTheme();
      TextTheme textTheme = GoogleFonts.poppinsTextTheme()
          .apply(bodyColor: theme.textColor(), displayColor: theme.textColor());
      themeData = ThemeData.dark().copyWith(
        dialogBackgroundColor: theme.cardDefaultColor(),
        textTheme: textTheme,
        brightness: Brightness.dark,
        dividerColor: theme.dividerColor(),
        cardColor: theme.cardDefaultColor(),
        dataTableTheme: DataTableThemeData(
          headingRowColor: MaterialStateColor.resolveWith((states) {
            return theme.cardDefaultColor();
          }),
          dataTextStyle: TextStyle(color: theme.textColor()),
          headingTextStyle: TextStyle(color: theme.titleColor()),
          dataRowColor: MaterialStateColor.resolveWith((states) {
            return theme.cardDefaultColor();
          }),
        ),
      );
    }
    return themeData;
  }

  bool lightTheme = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Headquarters',
        theme: getTheme(lightTheme),
        debugShowCheckedModeBanner: false,
        home: FutureBuilder<void>(
            future: connected,
            builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  return authStatus == AuthStatus.LoggedOut
                      ? AuthPage(
                          service: service,
                          onLogIn: onLogin,
                          theme: theme,
                        )
                      : HomePage(
                          lightTheme: lightTheme,
                          changeTheme: (bool value) {
                            setState(() {
                              void rebuild(Element el) {
                                lightTheme = value;

                                el.markNeedsBuild();
                                el.visitChildren(rebuild);
                              }

                              (context as Element).visitChildren(rebuild);
                            });
                          },
                          service: service,
                          theme: theme,
                        );
                default:
                  return Align(
                      child: Container(
                        child: CircularProgressIndicator(),
                      ),
                      alignment: Alignment.center);
              }
            }));
  }
}
