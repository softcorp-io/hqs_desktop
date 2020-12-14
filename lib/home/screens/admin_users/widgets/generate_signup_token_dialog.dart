import 'package:clipboard/clipboard.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hqs_desktop/constants/constants.dart';
import 'package:hqs_desktop/generated/hqs-user-service/proto/hqs-user-service.pb.dart';
import 'package:hqs_desktop/home/widgets/custom_dropdown_form_field.dart';
import 'package:hqs_desktop/service/hqs_service.dart';
import 'package:hqs_desktop/home/screens/admin_users/constants/text.dart';

class GenerateSignupTokenDialog extends StatelessWidget {
  final HqsService service;

  GenerateSignupTokenDialog({@required this.service}) : assert(service != null);

  @override
  Widget build(BuildContext context) {
    bool allowView = false;
    bool allowCreate = false;
    bool allowDelete = false;
    bool allowPermission = false;
    bool allowBlock = false;
    Token signupToken;
    final _formKey = GlobalKey<FormState>();
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return AlertDialog(
        title: Text(
          generateSignUpLinkTitle,
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.grey[900],
          ),
        ),
        content: Container(
          width: 800,
          height: 550,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                generateSignUpLinkRules,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
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
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(generateSignUpLinkSelectViewTitle),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  CustomDromDownMenu(
                                    validator: (value) {
                                      return null;
                                    },
                                    defaultBorderColor: Colors.grey[200],
                                    hintText: generateSignUpLinkSelectViewHint,
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
                          SizedBox(width: 18),
                          Flexible(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(generateSignUpLinkSelectCreateTitle),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  CustomDromDownMenu(
                                    validator: (value) {
                                      if (allowCreate &&
                                          (!allowView || !allowPermission)) {
                                        return generateSignUpLinkSelectCreateValidator;
                                      }
                                      return null;
                                    },
                                    defaultBorderColor: Colors.grey[200],
                                    hintText:
                                        generateSignUpLinkSelectCreateHint,
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
                                  Text(generateSignUpLinkSelectPermissionTitle),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  CustomDromDownMenu(
                                    validator: (value) {
                                      if (allowPermission && !allowView) {
                                        return generateSignUpLinkSelectPermissionValidator;
                                      }
                                      return null;
                                    },
                                    defaultBorderColor: Colors.grey[200],
                                    hintText:
                                        generateSignUpLinkSelectPermissionHint,
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
                          SizedBox(width: 18),
                          Flexible(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(generateSignUpLinkSelecDeleteTitle),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  CustomDromDownMenu(
                                    validator: (value) {
                                      if (allowDelete && !allowView) {
                                        return generateSignUpLinkSelectDeleteValidator;
                                      }
                                      return null;
                                    },
                                    defaultBorderColor: Colors.grey[200],
                                    hintText:
                                        generateSignUpLinkSelectDeleteHint,
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
                                  Text(generateSignUpLinkSelecBlockTitle),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  CustomDromDownMenu(
                                    validator: (value) {
                                      if (allowBlock && !allowView) {
                                        return generateSignUpLinkSelectBlockValidator;
                                      }
                                      return null;
                                    },
                                    defaultBorderColor: Colors.grey[200],
                                    hintText:
                                        generateSignUpLinkSelectBlockeHint,
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
                  ],
                ),
              ),
              SizedBox(height: 28),
              Center(
                child: Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(cardBorderRadius),
                    ),
                    width: 750,
                    height: 50,
                    child: TextButton(
                      onPressed: () {
                        if (signupToken != null) {
                          FlutterClipboard.copy(signupToken.token)
                              .then((value) {
                            Flushbar(
                              title: generateSignUpLinkCopyTokenSuccessTitle,
                              maxWidth: 450,
                              icon: Icon(
                                Icons.check_circle,
                                size: 28.0,
                                color: Colors.green,
                              ),
                              flushbarPosition: FlushbarPosition.TOP,
                              message: generateSignUpLinkCopyTokenSuccessText,
                              margin: EdgeInsets.all(8),
                              borderRadius: 8,
                              duration: Duration(seconds: 5),
                            )..show(context);
                          });
                        }
                      },
                      child: Text(
                        signupToken == null
                            ? copyTokenButtonNotGenerated
                            : copyTokenButtonGenerated,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              generateSignUpLinkCloseButton,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: Colors.red,
              ),
            ),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
            },
          ),
          TextButton(
            child: Text(
              generateSignUpLinkGenerateButton,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: kPrimaryColor,
              ),
            ),
            onPressed: () {
              if (_formKey.currentState.validate()) {
                service
                    .generateSignupToken(
                  allowView,
                  allowCreate,
                  allowPermission,
                  allowDelete,
                  allowBlock,
                )
                    .then((token) {
                  setState(() {
                    try {
                      signupToken = token;
                    } catch (e) {
                      print(e);
                    }
                  });
                });
              }
            },
          ),
        ],
      );
    });
  }
}
