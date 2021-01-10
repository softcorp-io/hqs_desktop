import 'package:flutter/material.dart';
import 'package:hqs_desktop/theme/theme.dart';

class CustomTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final Function(String value) validator;
  final Function(String value) onChange;
  final TextInputType keyboardType;
  final int maxLines;
  final int maxLength;
  final int minLines;
  final IconData icon;
  final String hintText;
  final String labelText;
  final bool obscure;
  final FocusNode focusNode;
  final HqsTheme theme;

  CustomTextFormField(
      {@required this.controller,
      @required this.focusNode,
      @required this.keyboardType,
      @required this.validator,
      @required this.hintText,
      @required this.labelText,
      @required this.maxLength,
      @required this.minLines,
      @required this.maxLines,
      @required this.theme,
      this.onChange,
      this.icon,
      @required this.obscure}) {
    assert(controller != null);
    assert(focusNode != null);
    assert(obscure != null);
    assert(maxLines != null);
    assert(minLines != null);
    assert(maxLength != null);
    assert(keyboardType != null);
    assert(theme != null);
  }

  @override
  State<StatefulWidget> createState() {
    return _CustomTextFormFieldState(
        controller: controller,
        validator: validator,
        onChange: onChange,
        icon: icon,
        hintText: hintText,
        labelText: labelText,
        obscure: obscure,
        keyboardType: keyboardType,
        maxLength: maxLength,
        minLines: minLines,
        maxLines: maxLines,
        focusNode: focusNode,
        theme: theme);
  }
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  final TextEditingController controller;
  final Function(String value) validator;
  final Function(String value) onChange;
  final TextInputType keyboardType;
  final int maxLines;
  final int maxLength;
  final int minLines;
  final IconData icon;
  final String hintText;
  final String labelText;
  final bool obscure;
  final FocusNode focusNode;
  final HqsTheme theme;

  _CustomTextFormFieldState(
      {@required this.controller,
      @required this.focusNode,
      @required this.keyboardType,
      @required this.validator,
      @required this.hintText,
      @required this.labelText,
      @required this.maxLength,
      @required this.minLines,
      @required this.maxLines,
      @required this.theme,
      this.onChange,
      this.icon,
      @required this.obscure}) {
    assert(controller != null);
    assert(focusNode != null);
    assert(obscure != null);
    assert(maxLines != null);
    assert(minLines != null);
    assert(maxLength != null);
    assert(keyboardType != null);
    assert(theme != null);
    focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscure,
      readOnly: false,
      focusNode: focusNode,
      enabled: true,
      controller: controller,
      onChanged: (value) {
        if (this.onChange == null) {
          return;
        }
        onChange(value);
      },
      keyboardType: keyboardType,
      maxLength: maxLength,
      maxLines: maxLines,
      minLines: minLines,
      style: TextStyle(color: theme.textColor()),
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: theme.primaryColor(), width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: theme.formBorderColor(), width: 1.0),
        ),
        labelStyle: TextStyle(color: theme.textColor()),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: theme.dangerColor(), width: 1.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: theme.dangerColor(), width: 1.0),
        ),
        errorStyle: TextStyle(color: theme.dangerColor()),
        hintText: hintText,
        labelText: labelText,
        suffixIcon: Icon(
          icon,
          color: focusNode.hasFocus ? theme.primaryColor() : theme.iconColor(),
        ),
        hintStyle: TextStyle(color: theme.hintColor()),
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
