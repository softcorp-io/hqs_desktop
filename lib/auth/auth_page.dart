import 'package:flutter/material.dart';
import 'package:hqs_desktop/auth/constants/text.dart';
import 'package:hqs_desktop/service/hqs_user_service.dart';
import 'package:hqs_desktop/auth/widgets/login.dart';
import 'package:hqs_desktop/auth/widgets/header.dart';
import 'package:hqs_desktop/auth/widgets/footer.dart';
import 'package:hqs_desktop/theme/constants.dart';

class AuthPage extends StatefulWidget {
  final HqsService service;
  final Function onLogIn;
  AuthPage({@required this.service, @required this.onLogIn})
      : assert(service != null),
        assert(onLogIn != null);

  @override
  _AuthPageState createState() =>
      _AuthPageState(service: service, onLogIn: onLogIn);
}

class _AuthPageState extends State<AuthPage> {
  final HqsService service;
  final Function onLogIn;

  _AuthPageState({@required this.service, @required this.onLogIn})
      : assert(service != null),
        assert(onLogIn != null);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        color: loginDarkColor,
        child: Stack(
          children: [
            // defines the background color of the login screen
            Row(
              children: [
                Container(
                  height: double.infinity,
                  width: size.width,
                ),
              ],
            ),
            // Design wavy header
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
                            welcomePlatformTitle,
                            style: TextStyle(
                              fontSize: 28,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            welcomePlatformSubTitle,
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
                      "Copyright " + DateTime.now().year.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            LogIn(
              service: service,
              onLogIn: onLogIn,
            )
          ],
        ),
      ),
    );
  }
}
