import 'package:flutter/material.dart';
import 'package:hqs_desktop/service/hqs_service.dart';

Color kPrimaryColor = Color(0xFF2979FF);
Color kLightPrimaryColor = Colors.blue[500];
Color kLoginColor = Color(0xFFFFCC80);
Color kDarkColor = Colors.grey[900];
Color kBlueGreyColor = Colors.blueGrey[200];

bool female = true;
bool male = false;

enum Option { LogIn, SignUp }

enum AuthStatus { LoggedIn, LoggedOut }
