import 'package:flutter/material.dart';
import 'package:dart_hqs/hqs_user_service.pb.dart';
import 'package:hqs_desktop/home/screens/admin_users/constants/text.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hqs_desktop/home/widgets/custom_dropdown_form_field.dart';
import 'package:hqs_desktop/home/widgets/custom_flushbar_error.dart';
import 'package:hqs_desktop/home/widgets/custom_flushbar_success.dart';
import 'package:hqs_desktop/service/hqs_user_service.dart';

class EditUserDialog extends StatelessWidget {
  final HqsService service;
  final User user;
  final Function onUpdate;
  final BuildContext buildContext;

  EditUserDialog(
      {@required this.service,
      @required this.user,
      @required this.onUpdate,
      @required this.buildContext})
      : assert(service != null),
        assert(onUpdate != null),
        assert(buildContext != null),
        assert(user != null);

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    bool allowView = user.allowView;
    bool allowCreate = user.allowCreate;
    bool allowDelete = user.allowDelete;
    bool allowPermission = user.allowPermission;
    bool allowBlock = user.allowBlock;
    bool allowReset = user.allowResetPassword;
    return StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
          title: Text(
            userSourceEditDialogTitle(user),
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
                  userSourceEditDialogPermissionRuleText,
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
                                    Text(userSourceEditDialogViewAccessText),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    CustomDromDownMenu(
                                      validator: (value) {
                                        return null;
                                      },
                                      hintText:
                                          userSourceEditDialogViewAccessHint,
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
                                    Text(userSourceEditDialogCreateAccessText),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    CustomDromDownMenu(
                                      validator: (value) {
                                        if (allowCreate &&
                                            !(allowView && allowPermission)) {
                                          return userSourceEditDialogCreateAccessValidator;
                                        }
                                        return null;
                                      },
                                      hintText:
                                          userSourceEditDialogCreateAccessHint,
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
                                    Text(
                                        userSourceEditDialogPermissionAccessText),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    CustomDromDownMenu(
                                      validator: (value) {
                                        if (allowPermission && !allowView) {
                                          return userSourceEditDialogPermissionAccessValidator;
                                        }
                                        return null;
                                      },
                                      hintText:
                                          userSourceEditDialogPermissionAccessHint,
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
                                    Text(userSourceEditDialogDeleteAccessText),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    CustomDromDownMenu(
                                      validator: (value) {
                                        if (allowDelete && !allowView) {
                                          return userSourceEditDialogDeleteAccessValidator;
                                        }
                                        return null;
                                      },
                                      hintText:
                                          userSourceEditDialogDeleteAccessHint,
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
                                    Text(userSourceEditDialogBlockAccessText),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    CustomDromDownMenu(
                                      validator: (value) {
                                        if (allowBlock && !allowView) {
                                          return userSourceEditDialogBlockAccessValidator;
                                        }
                                        return null;
                                      },
                                      hintText:
                                          userSourceEditDialogBlockAccessHint,
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
                                    Text(userSourceEditDialogResetAccessText),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    CustomDromDownMenu(
                                      validator: (value) {
                                        if (allowReset && !allowView) {
                                          return editUserSelectResetValidator;
                                        }
                                        return null;
                                      },
                                      hintText:
                                          userSourceEditDialogResetAccessHint,
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
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                userSourceEditDialogCloseBtnText,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: Theme.of(context).errorColor,
                ),
              ),
              onPressed: () {
                Navigator.of(buildContext, rootNavigator: true).pop();
              },
            ),
            TextButton(
              child: Text(
                userSourceEditDialogUpdateBtnText,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              onPressed: () {
                service
                    .updateUsersPermissions(
                  user.id,
                  allowView,
                  allowCreate,
                  allowPermission,
                  allowDelete,
                  allowBlock,
                  allowReset,
                )
                    .catchError((error) {
                  CustomFlushbarError(
                    title: userSourceEditDialogExceptionTitle,
                    body: userSourceEditDialogExceptionText(user),
                    context: context,
                  ).getFlushbar().show(context);
                }).then((value) {
                  onUpdate();
                  Navigator.of(buildContext, rootNavigator: true).pop();
                  CustomFlushbarSuccess(
                    title: userSourceEditDialogSuccessTitle,
                    body: userSourceEditDialogSuccessText(user),
                    context: context,
                  ).getFlushbar().show(context);
                  return value;
                });
              },
            ),
          ]);
    });
  }
}
