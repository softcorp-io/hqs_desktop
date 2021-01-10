import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:hqs_desktop/theme/constants.dart';

enum FlushSize { Small, Medium, Large }

class CustomFlushbarSuccess {
  final String title;
  final String body;
  final BuildContext context;

  CustomFlushbarSuccess(
      {@required this.title, @required this.body, @required this.context})
      : assert(title != null),
        assert(context != null),
        assert(body != null);

  Flushbar getFlushbar() {
    return Flushbar(
        maxWidth: 800,
        title: title,
        icon: Icon(
          Icons.check_circle_outline,
          size: 28.0,
          color: successColor,
        ),
        flushbarPosition: FlushbarPosition.TOP,
        message: body,
        margin: EdgeInsets.all(8),
        borderRadius: 8,
        duration: Duration(seconds: 5));
  }
}
