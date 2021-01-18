import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hqs_desktop/home/screens/organization/constants/text.dart';
import 'package:hqs_desktop/home/widgets/custom_dropdown_form_field.dart';
import 'package:hqs_desktop/home/widgets/custom_flushbar_error.dart';
import 'package:hqs_desktop/home/widgets/custom_flushbar_success.dart';
import 'package:hqs_desktop/home/widgets/custom_text_form_field.dart';
import 'package:hqs_desktop/service/hqs_service.dart';
import 'package:dart_hqs/hqs_privilege_service.pbgrpc.dart' as privilegeService;

class CreateUserDialog extends StatelessWidget {
  final HqsService service;
  final Function onUpdate;

  bool gender = true;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  CreateUserDialog({@required this.service, @required this.onUpdate})
      : assert(service != null),
        assert(onUpdate != null);

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return AlertDialog(
          title: Text(
            creatUserDialogTitle,
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Container(
            width: 800,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 32),
                  Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                child: CustomTextFormField(
                                  maxLength: 30,
                                  minLines: 1,
                                  maxLines: 1,
                                  keyboardType: TextInputType.name,
                                  controller: _nameController,
                                  hintText: createUserNameHint,
                                  labelText: createUserNameText,
                                  obscure: false,
                                  focusNode: FocusNode(),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return createUserNameValidator;
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(width: 16),
                              Flexible(
                                child: CustomTextFormField(
                                  maxLength: 30,
                                  minLines: 1,
                                  maxLines: 1,
                                  keyboardType: TextInputType.emailAddress,
                                  controller: _emailController,
                                  hintText: createUserEmailHint,
                                  labelText: createUserEmailText,
                                  obscure: false,
                                  focusNode: FocusNode(),
                                  validator: (value) {
                                    var validEmail = RegExp(
                                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                        .hasMatch(value);
                                    if (!validEmail) {
                                      return createUserEmailValidator;
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ]),
                        SizedBox(height: 30),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                child: Padding(
                                  padding: EdgeInsets.only(top: 32),
                                  child: CustomTextFormField(
                                    maxLength: 30,
                                    minLines: 1,
                                    maxLines: 1,
                                    keyboardType: TextInputType.text,
                                    controller: _passwordController,
                                    hintText: createUserPasswordHint,
                                    labelText: createUserPasswordText,
                                    obscure: true,
                                    focusNode: FocusNode(),
                                    validator: (value) {
                                      if (value.length < 6) {
                                        return createUserPasswordlValidator;
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(width: 18),
                              Flexible(
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(createUserSelectGenderTitle),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      CustomDromDownMenu(
                                        validator: (value) {
                                          return null;
                                        },
                                        hintText: createUserSelectGenderHint,
                                        items: [
                                          DropdownMenuItem(
                                            child: Text('female'),
                                            value: true,
                                          ),
                                          DropdownMenuItem(
                                            child: Text('male'),
                                            value: false,
                                          ),
                                        ],
                                        value: gender,
                                        onChanged: (value) {
                                          setState(() {
                                            gender = value;
                                          });
                                        },
                                      ),
                                    ]),
                              ),
                            ]),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                "Close",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: Theme.of(context).errorColor,
                ),
              ),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
            ),
            TextButton(
              child: Text(
                "Create",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  service
                      .createUser(_nameController.text, _emailController.text,
                          _passwordController.text, gender)
                      .catchError((error) {
                    CustomFlushbarError(
                            title: createUserDialogExceptionTitle,
                            body: createUserDialogExceptionText,
                            context: context)
                        .getFlushbar()
                        .show(context);
                  }).then((response) {
                    service.getAllUsers().then((value) {
                      setState(() {});
                    });
                    onUpdate();
                    Navigator.of(context, rootNavigator: true).pop();
                    CustomFlushbarSuccess(
                            title: createUserDialogSuccessTitle,
                            body: createUserDialogSuccessText,
                            context: context)
                        .getFlushbar()
                        .show(context);
                  });
                }
              },
            ),
          ]);
    });
  }
}
