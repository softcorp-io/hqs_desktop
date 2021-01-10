import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

enum FlushSize { Small, Medium, Large }

class CustomFlushbarError {
  final String title;
  final String body;
  final BuildContext context;

  CustomFlushbarError(
      {@required this.title, @required this.body, @required this.context})
      : assert(title != null),
        assert(context != null),
        assert(body != null);

  Flushbar getFlushbar() {
    return Flushbar(
        maxWidth: 800,
        title: title,
        icon: Icon(
          Icons.error_outline,
          size: 28.0,
          color: Theme.of(context).errorColor,
        ),
        flushbarPosition: FlushbarPosition.TOP,
        message: body,
        margin: EdgeInsets.all(8),
        borderRadius: 8,
        duration: Duration(seconds: 5));
  }
}
