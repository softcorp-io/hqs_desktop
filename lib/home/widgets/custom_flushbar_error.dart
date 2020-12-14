import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

enum FlushSize { Small, Medium, Large }

class CustomFlushbarError extends Flushbar {
  final Icon icon;
  final String title;
  final String body;
  final FlushSize flushSize;
  CustomFlushbarError(
      {@required this.icon,
      @required this.title,
      @required this.body,
      @required this.flushSize})
      : assert(icon != null),
        assert(flushSize != null);
  @override
  Widget build(BuildContext context) {
    return Flushbar();
  }
}
