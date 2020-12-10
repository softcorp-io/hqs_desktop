import 'package:flutter/material.dart';
import 'package:hqs_desktop/service/hqs_service.dart';
import 'package:hqs_desktop/screens/auth/widgets/login_form.dart';
import 'package:hqs_desktop/screens/auth/widgets/signup_form.dart';
import 'package:hqs_desktop/constants/constants.dart';
import 'package:hqs_desktop/screens/auth/widgets/header.dart';
import 'package:hqs_desktop/screens/auth/widgets/footer.dart';

class AuthPage extends StatefulWidget {
  final HqsService service;
  final Function onLogIn;

  AuthPage({@required this.service, @required this.onLogIn});

  @override
  _AuthPageState createState() =>
      _AuthPageState(service: service, onLogIn: onLogIn);
}

class _AuthPageState extends State<AuthPage> {
  final HqsService service;
  final Function onLogIn;

  _AuthPageState({@required this.service, @required this.onLogIn});

  Option selectedOption = Option.LogIn;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        child: Stack(
          children: [
            // defines the background color of the login screen
            Row(
              children: [
                Container(
                  height: double.infinity,
                  width: size.width,
                  color: kDarkBlue,
                ),
              ],
            ),

            // Design header
            LoginWavyHeader(),
            Align(
              alignment: Alignment.bottomCenter,
              child: WavyFooter(),
            ),
            // Welcome to the platform
            Align(
              alignment: Alignment.centerLeft,
              child: size.width > 600
                  ? Padding(
                      padding: EdgeInsets.all(32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Welcome to the platform !",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "A software platform made by Softcorp",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    )
                  : Padding(
                      padding: EdgeInsets.zero,
                    ),
            ),

            // Copyright information
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      Icons.copyright,
                      color: Colors.white,
                      size: 15,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      "Copyright 2020",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Singup & singin card placeholder
            AnimatedSwitcher(
              duration: Duration(milliseconds: 500),
              transitionBuilder: (widget, animation) =>
                  ScaleTransition(child: widget, scale: animation),
              child: selectedOption == Option.LogIn
                  ? LogIn(
                      service: service,
                      onSignUpSelected: () {
                        setState(() {
                          selectedOption = Option.SignUp;
                        });
                      },
                      onLogIn: onLogIn,
                    )
                  : SignUp(
                      service: service,
                      onLogInSelected: () {
                        setState(() {
                          selectedOption = Option.LogIn;
                        });
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
