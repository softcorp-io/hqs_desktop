import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hqs_desktop/constants/constants.dart';
import 'package:dart_hqs/hqs_user_service.pb.dart';
import 'package:hqs_desktop/home/widgets/custom_dropdown_form_field.dart';
import 'package:hqs_desktop/home/widgets/custom_flushbar_success.dart';
import 'package:hqs_desktop/service/hqs_user_service.dart';
import 'package:hqs_desktop/home/screens/admin_users/constants/text.dart';

class GenerateSignupTokenDialog extends StatelessWidget {
  final HqsService service;

  GenerateSignupTokenDialog({
    @required this.service,
  }) : assert(service != null);

  @override
  Widget build(BuildContext context) {
    bool allowView = false;
    bool allowCreate = false;
    bool allowDelete = false;
    bool allowPermission = false;
    bool allowBlock = false;
    bool allowReset = false;
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
                          SizedBox(width: 18),
                          Flexible(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(generateSignUpLinkSelecResetTitle),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  CustomDromDownMenu(
                                    validator: (value) {
                                      if (allowReset && !allowView) {
                                        return generateSignupLinkSelectResetValidator;
                                      }
                                      return null;
                                    },
                                    hintText: generateSignUpLinkSelectResetHint,
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
                        ]),
                  ],
                ),
              ),
              SizedBox(height: 28),
              Center(
                child: Container(
                  width: 750,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(cardBorderRadius),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(6),
                        child: Container(
                          width: 600,
                          child: Text(
                              signupToken == null
                                  ? copyTokenButtonNotGenerated
                                  : signupToken.url + signupToken.token,
                              style: TextStyle(
                                fontSize: 16,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis),
                        ),
                      ),
                      Spacer(),
                      Container(
                        height: 50,
                        child: IconButton(
                          color: signupToken == null
                              ? Theme.of(context).textTheme.bodyText1.color
                              : Theme.of(context).primaryColor,
                          hoverColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          icon: Icon(Icons.copy),
                          onPressed: () {
                            if (signupToken != null) {
                              FlutterClipboard.copy(
                                      signupToken.url + signupToken.token)
                                  .then((value) {
                                CustomFlushbarSuccess(
                                        title:
                                            generateSignUpLinkCopyTokenSuccessTitle,
                                        body:
                                            generateSignUpLinkCopyTokenSuccessText,
                                        context: context)
                                    .getFlushbar()
                                    .show(context);
                              });
                            }
                          },
                        ),
                      ),
                    ],
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
                color: Theme.of(context).errorColor,
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
                color: Theme.of(context).primaryColor,
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
                  allowReset,
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
