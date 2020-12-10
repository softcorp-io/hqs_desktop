import 'package:flutter/material.dart';
import 'package:hqs_desktop/constants/constants.dart';

class CustomDromDownMenu extends StatelessWidget {
  final Function(dynamic value) validator;
  final Function(dynamic value) onChanged;
  final String hintText;
  final Color defaultBorderColor;
  final List<DropdownMenuItem> items;
  final dynamic value;

  CustomDromDownMenu({
    @required this.validator,
    @required this.hintText,
    @required this.items,
    @required this.defaultBorderColor,
    @required this.value,
    this.onChanged,
  }) {
    assert(items != null);
    assert(value != null);
    assert(defaultBorderColor != null);
  }
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      items: items,
      value: value,
      hint: Text(hintText),
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: kPrimaryColor, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[300], width: 1.0),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red[600], width: 1.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red[600], width: 1.0),
        ),
        errorStyle: TextStyle(color: Colors.red[600]),
      ),
      isExpanded: true,
      onChanged: (value) {
        if (this.onChanged == null) {
          return;
        }
        onChanged(value);
      },
      validator: (value) {
        if (this.validator == null) {
          return value;
        }
        return this.validator(value);
      },
    );
  }
}