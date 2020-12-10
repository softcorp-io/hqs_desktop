import 'package:flutter/material.dart';
import 'package:hqs_desktop/service/hqs_service.dart';
import 'package:window_size/window_size.dart';
import 'dart:io';
import 'package:hqs_desktop/screens/auth/auth_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hqs_desktop/constants/constants.dart';
import 'package:hqs_desktop/screens/home/home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowTitle("Headquarters");
    setWindowMinSize(Size(800, 900));
  }
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  HqsService service = new HqsService(addr: "localhost", port: 9000);

  AuthStatus authStatus = AuthStatus.LoggedOut;

  @override
  Widget build(BuildContext context) {
    service.setLogout(() {
      setState(() {
        authStatus = AuthStatus.LoggedOut;
      });
    });
    return MaterialApp(
        title: 'Headquarters',
        theme: ThemeData(
          primaryColor: kPrimaryColor,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          textTheme: GoogleFonts.poppinsTextTheme(),
        ),
        debugShowCheckedModeBanner: false,
        home: AnimatedSwitcher(
          duration: Duration(milliseconds: 500),
          transitionBuilder: (widget, animation) =>
              FadeTransition(child: widget, opacity: animation),
          child: authStatus == AuthStatus.LoggedOut
              ? AuthPage(
                  service: service,
                  onLogIn: () {
                    setState(() {
                      authStatus = AuthStatus.LoggedIn;
                    });
                  },
                )
              : HomePage(service: service),
        ));
  }
}
