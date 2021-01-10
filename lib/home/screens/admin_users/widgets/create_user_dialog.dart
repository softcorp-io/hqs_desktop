import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hqs_desktop/home/screens/admin_users/constants/text.dart';
import 'package:hqs_desktop/home/widgets/custom_dropdown_form_field.dart';
import 'package:hqs_desktop/home/widgets/custom_flushbar_error.dart';
import 'package:hqs_desktop/home/widgets/custom_flushbar_success.dart';
import 'package:hqs_desktop/home/widgets/custom_text_form_field.dart';
import 'package:hqs_desktop/service/hqs_user_service.dart';

class CreateUserDialog extends StatelessWidget {
  final HqsService service;
  final Function onUpdate;

  CreateUserDialog({@required this.service, @required this.onUpdate})
      : assert(service != null),
        assert(onUpdate != null);

  @override
  Widget build(BuildContext context) {
    bool allowView = false;
    bool allowCreate = false;
    bool allowDelete = false;
    bool allowPermission = false;
    bool allowBlock = false;
    bool allowReset = false;
    bool gender = true;
    final _nameController = TextEditingController();
    final _emailController = TextEditingController();
    final _passwordController = TextEditingController();
    final _formKey = GlobalKey<FormState>();
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
            height: 650,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  createUserPermissionkRules,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
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
                                icon: Icons.person,
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
                                icon: Icons.mail_outline_rounded,
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
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              child: Padding(
                                padding: EdgeInsets.only(top: 28),
                                child: CustomTextFormField(
                                  maxLength: 30,
                                  minLines: 1,
                                  maxLines: 1,
                                  keyboardType: TextInputType.text,
                                  controller: _passwordController,
                                  hintText: createUserPasswordHint,
                                  labelText: createUserPasswordText,
                                  obscure: true,
                                  icon: Icons.lock,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(createUserSelectViewTitle),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    CustomDromDownMenu(
                                      validator: (value) {
                                        return null;
                                      },
                                      hintText: createUserSelectViewHint,
                                      items: [
                                        DropdownMenuItem(
                                          child: Text('true'),
                                          value: true,
                                        ),
                                        DropdownMenuItem(
                                          child: Text('false'),
                                          value: false,
                                        ),
                                      ],
                                      value: allowView,
                                      onChanged: (value) {
                                        setState(() {
                                          allowView = value;
                                        });
                                      },
                                    ),
                                  ]),
                            ),
                          ]),
                      SizedBox(height: 28),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(createUserSelectCreateTitle),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    CustomDromDownMenu(
                                      validator: (value) {
                                        if (allowCreate &&
                                            !(allowView && allowPermission)) {
                                          return createUserSelectCreateValidator;
                                        }
                                        return null;
                                      },
                                      hintText: createUserSelectCreateHint,
                                      items: [
                                        DropdownMenuItem(
                                          child: Text('true'),
                                          value: true,
                                        ),
                                        DropdownMenuItem(
                                          child: Text('false'),
                                          value: false,
                                        ),
                                      ],
                                      value: allowCreate,
                                      onChanged: (value) {
                                        setState(() {
                                          allowCreate = value;
                                        });
                                      },
                                    ),
                                  ]),
                            ),
                            SizedBox(width: 18),
                            Flexible(
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(createUserSelectPermissionTitle),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    CustomDromDownMenu(
                                      validator: (value) {
                                        if (allowPermission && !allowView) {
                                          return createUserSelectPermissionValidator;
                                        }
                                        return null;
                                      },
                                      hintText: createUserSelectPermissionHint,
                                      items: [
                                        DropdownMenuItem(
                                          child: Text('true'),
                                          value: true,
                                        ),
                                        DropdownMenuItem(
                                          child: Text('false'),
                                          value: false,
                                        ),
                                      ],
                                      value: allowPermission,
                                      onChanged: (value) {
                                        setState(() {
                                          allowPermission = value;
                                        });
                                      },
                                    ),
                                  ]),
                            ),
                          ]),
                      SizedBox(height: 28),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(createUserSelectDeleteTitle),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    CustomDromDownMenu(
                                      validator: (value) {
                                        if (allowDelete && !allowView) {
                                          return createUserSelectDeleteValidator;
                                        }
                                        return null;
                                      },
                                      hintText: createUserSelectDeleteHint,
                                      items: [
                                        DropdownMenuItem(
                                          child: Text('true'),
                                          value: true,
                                        ),
                                        DropdownMenuItem(
                                          child: Text('false'),
                                          value: false,
                                        ),
                                      ],
                                      value: allowDelete,
                                      onChanged: (value) {
                                        setState(() {
                                          allowDelete = value;
                                        });
                                      },
                                    ),
                                  ]),
                            ),
                            SizedBox(width: 18),
                            Flexible(
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(createUserSelectBlockTitle),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    CustomDromDownMenu(
                                      validator: (value) {
                                        if (allowBlock && !allowView) {
                                          return createUserSelectBlockValidator;
                                        }
                                        return null;
                                      },
                                      hintText: createUserSelectBlockHint,
                                      items: [
                                        DropdownMenuItem(
                                          child: Text('true'),
                                          value: true,
                                        ),
                                        DropdownMenuItem(
                                          child: Text('false'),
                                          value: false,
                                        ),
                                      ],
                                      value: allowBlock,
                                      onChanged: (value) {
                                        setState(() {
                                          allowBlock = value;
                                        });
                                      },
                                    ),
                                  ]),
                            ),
                          ]),
                      SizedBox(height: 28),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(createUserSelectResetTitle),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    CustomDromDownMenu(
                                      validator: (value) {
                                        if (allowReset && !allowView) {
                                          return createUserSelectResetValidator;
                                        }
                                        return null;
                                      },
                                      hintText: createUserSelectResetHint,
                                      items: [
                                        DropdownMenuItem(
                                          child: Text('true'),
                                          value: true,
                                        ),
                                        DropdownMenuItem(
                                          child: Text('false'),
                                          value: false,
                                        ),
                                      ],
                                      value: allowReset,
                                      onChanged: (value) {
                                        setState(() {
                                          allowReset = value;
                                        });
                                      },
                                    ),
                                  ]),
                            ),
                            SizedBox(width: 18),
                            Flexible(
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                createUserDialogCreateButtonText,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  service
                      .createUser(
                          _nameController.text,
                          _emailController.text,
                          _passwordController.text,
                          allowView,
                          allowCreate,
                          allowPermission,
                          allowDelete,
                          allowBlock,
                          allowReset,
                          gender)
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
