import 'package:flutter/material.dart';
import 'package:hqs_desktop/service/hqs_user_service.dart';
import 'package:desktop_window/desktop_window.dart';
import 'dart:io';
import 'package:hqs_desktop/auth/auth_page.dart';
import 'package:hqs_desktop/constants/constants.dart';
import 'package:hqs_desktop/home/home.dart';
import 'package:hqs_desktop/theme/hqs_dark_theme.dart';
import 'package:hqs_desktop/theme/hqs_light_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hqs_desktop/home/screens/settings/settings_page.dart';

void main() async {
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
  AuthStatus authStatus;
  HqsService service;
  ThemeData lightTheme = HqsLightTheme().getTheme();
  ThemeData darkTheme = HqsDarkTheme().getTheme();
  ThemeData theme;
  Future<void> platformReady;

  _HqsAppState() {
    service = new HqsService(
        addr: "34.77.45.46", port: 9000, onLogin: onLogin, onLogout: onLogout);
    platformReady = setupPlatform();
  }

  onLogin() {
    setState(() {
      authStatus = AuthStatus.LoggedIn;
    });
  }

  onLogout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("stored_token");
    setState(() {
      authStatus = AuthStatus.LoggedOut;
    });
  }

  Future<void> setupPlatform() async {
    await service.connect();
    // setup theme
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String chosenTheme = prefs.getString('theme');
    if (chosenTheme == null) {
      theme = lightTheme;
      prefs.setString('theme', 'light');
    } else {
      switch (chosenTheme) {
        case 'light':
          theme = lightTheme;
          break;
        case 'dark':
          theme = darkTheme;
          break;
        default:
          theme = lightTheme;
          prefs.setString('theme', 'light');
          break;
      }
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
        future: platformReady,
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return MaterialApp(
                title: 'Headquarters',
                theme: theme,
                debugShowCheckedModeBanner: false,
                home: authStatus == AuthStatus.LoggedOut
                    ? AuthPage(
                        service: service,
                        onLogIn: onLogin,
                      )
                    : HomePage(
                        changeTheme: (HqsTheme changeTheme) {
                          switch (changeTheme) {
                            case HqsTheme.dark:
                              setState(() {
                                theme = darkTheme;
                              });
                              break;
                            case HqsTheme.light:
                              setState(() {
                                theme = lightTheme;
                              });
                              break;
                          }
                        },
                        service: service,
                      ),
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
