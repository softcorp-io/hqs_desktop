import 'package:flutter/material.dart';

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
    );
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
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        suffixIcon: Icon(
          icon,
          color: focusNode.hasFocus
              ? Theme.of(context).primaryColor
              : Theme.of(context).iconTheme.color,
        ),
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
