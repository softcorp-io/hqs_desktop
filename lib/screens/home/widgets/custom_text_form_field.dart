import 'package:flutter/material.dart';
import 'package:hqs_desktop/constants/constants.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final Function(String value) validator;
  final Function(String value) onChange;
  final Icon icon;
  final String hintText;
  final String labelText;
  final bool obscure;
  final Color defaultBorderColor;

  CustomTextFormField(
      {@required this.controller,
      @required this.validator,
      @required this.hintText,
      @required this.labelText,
      @required this.defaultBorderColor,
      this.onChange,
      this.icon,
      @required this.obscure}) {
    assert(controller != null);
    assert(defaultBorderColor != null);
    assert(obscure != null);
  }
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscure,
      readOnly: false,
      enabled: true,
      controller: controller,
      onChanged: (value) {
        if (this.onChange == null) {
          return;
        }
        onChange(value);
      },
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: kPrimaryColor, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: defaultBorderColor, width: 1.0),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red[600], width: 1.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red[600], width: 1.0),
        ),
        errorStyle: TextStyle(color: Colors.red[600]),
        hintText: hintText,
        labelText: labelText,
        suffixIcon: icon,
      ),
      validator: (value) {
        if (this.validator == null) {
          return value;
        }
        return this.validator(value);
      },
    );
  }
}
