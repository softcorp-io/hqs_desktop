import 'package:flutter/material.dart';
import 'package:hqs_desktop/service/hqs_service.dart';
import 'package:window_size/window_size.dart';
import 'dart:io';
import 'package:hqs_desktop/login/login.dart';
import 'package:hqs_desktop/signup/signup.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hqs_desktop/constants/constants.dart';
import 'package:hqs_desktop/login/header.dart';
import 'package:hqs_desktop/login/footer.dart';



void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowTitle("My Desktop App");
    setWindowMinSize(Size(800, 800));
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  HqsService service = new HqsService("localhost", 9000);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Web',
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      debugShowCheckedModeBanner: false,
      home: HomePage(service: service,),
    );
  }
}

class HomePage extends StatefulWidget {
  final HqsService service;
  HomePage({@required this.service});

  @override
  _HomePageState createState() => _HomePageState(service: service);
}

class _HomePageState extends State<HomePage> {
    final HqsService service;
  _HomePageState({this.service});

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
                      size: 12,
                    ),

                    SizedBox(
                      width: 8,
                    ),

                    Text(
                      "Copyright 2020",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),

                  ],
                ),
              ),
            ),

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