import 'package:flutter/material.dart';
import 'package:hqs_desktop/service/hqs_service.dart';
import 'package:hqs_desktop/login/login.dart';
import 'package:hqs_desktop/signup/signup.dart';
import 'package:hqs_desktop/constants/constants.dart';
import 'package:hqs_desktop/login/header.dart';
import 'package:hqs_desktop/login/footer.dart';


class LoginPage extends StatefulWidget {
  final HqsService service;
  final Function onLogIn;

  LoginPage({@required this.service, @required this.onLogIn});

  @override
  _LoginPageState createState() => _LoginPageState(service: service, onLogIn: onLogIn);
}

class _LoginPageState extends State<LoginPage> {
    final HqsService service;
    final Function onLogIn;

  _LoginPageState({@required this.service, @required this.onLogIn});

  Option selectedOption = Option.LogIn;

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    print(size.height);
    print(size.width);

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
                  color: Colors.orange,
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
              child: Padding(
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

              transitionBuilder: (widget, animation) => ScaleTransition(
                child: widget, 
                scale: animation
              ),

              child: selectedOption == Option.LogIn
              ? LogIn(service: service,
                onSignUpSelected: () {
                  setState(() {
                    selectedOption = Option.SignUp;
                  });
                },
                onLogIn: onLogIn,
              )
              : SignUp(
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