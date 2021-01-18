import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hqs_desktop/home/screens/organization/constants/text.dart';
import 'package:hqs_desktop/home/widgets/custom_dropdown_form_field.dart';
import 'package:hqs_desktop/home/widgets/custom_flushbar_error.dart';
import 'package:hqs_desktop/home/widgets/custom_flushbar_success.dart';
import 'package:hqs_desktop/home/widgets/custom_text_form_field.dart';
import 'package:hqs_desktop/service/hqs_service.dart';
import 'package:dart_hqs/hqs_privilege_service.pbgrpc.dart' as privilegeService;

class EditPrivilegeDialog extends StatelessWidget {
  final HqsService service;
  final Function onUpdate;

  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final privilegeService.Privilege privilege;

  bool viewAccess = false;
  bool createAccess = false;
  bool deleteAccess = false;
  bool blockAccess = false;
  bool managePrivileges = false;
  bool resetPasswordAccess = false;

  EditPrivilegeDialog(
      {@required this.service,
      @required this.onUpdate,
      @required this.privilege})
      : assert(service != null),
        assert(privilege != null),
        assert(onUpdate != null) {
    viewAccess = privilege.viewAllUsers;
    createAccess = privilege.createUser;
    deleteAccess = privilege.deleteUser;
    blockAccess = privilege.blockUser;
    managePrivileges = privilege.managePrivileges;
    resetPasswordAccess = privilege.sendResetPasswordEmail;
    _nameController.text = privilege.name;
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return AlertDialog(
          title: Text(
            "Edit Privilege",
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Container(
            width: 800,
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Select View Access"),
                                SizedBox(
                                  height: 8,
                                ),
                                CustomDromDownMenu(
                                  validator: (value) {
                                    return null;
                                  },
                                  hintText: "Select View Access",
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
                                  value: viewAccess,
                                  onChanged: (value) {
                                    setState(() {
                                      viewAccess = value;
                                    });
                                  },
                                ),
                              ]),
                        ),
                        SizedBox(width: 16),
                        Flexible(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Select Block Access"),
                                SizedBox(
                                  height: 8,
                                ),
                                CustomDromDownMenu(
                                  validator: (value) {
                                    if (blockAccess && !viewAccess) {
                                      return "Block access requires view access";
                                    }
                                    return null;
                                  },
                                  hintText: "Select Block Access",
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
                                  value: blockAccess,
                                  onChanged: (value) {
                                    setState(() {
                                      blockAccess = value;
                                    });
                                  },
                                ),
                              ]),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Select Create Access"),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  CustomDromDownMenu(
                                    validator: (value) {
                                      if (createAccess && !viewAccess) {
                                        return "Block access requires view access";
                                      }
                                      return null;
                                    },
                                    hintText: "Select Create Access",
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
                                    value: createAccess,
                                    onChanged: (value) {
                                      setState(() {
                                        createAccess = value;
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
                                  Text("Select Manage Privileges"),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  CustomDromDownMenu(
                                    validator: (value) {
                                      if (managePrivileges && !viewAccess) {
                                        return "Block access requires view access";
                                      }
                                      return null;
                                    },
                                    hintText: "Select Manage Privileges",
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
                                    value: managePrivileges,
                                    onChanged: (value) {
                                      setState(() {
                                        managePrivileges = value;
                                      });
                                    },
                                  ),
                                ]),
                          ),
                        ]),
                    SizedBox(height: 30),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Select Delete Access"),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  CustomDromDownMenu(
                                    validator: (value) {
                                      if (deleteAccess && !viewAccess) {
                                        return "Block access requires view access";
                                      }
                                      return null;
                                    },
                                    hintText: "Select Delete Access",
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
                                    value: deleteAccess,
                                    onChanged: (value) {
                                      setState(() {
                                        deleteAccess = value;
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
                                  Text("Select Reset Password Access"),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  CustomDromDownMenu(
                                    validator: (value) {
                                      if (resetPasswordAccess && !viewAccess) {
                                        return "Block access requires view access";
                                      }
                                      return null;
                                    },
                                    hintText:
                                        "Select Select Reset Password Access",
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
                                    value: resetPasswordAccess,
                                    onChanged: (value) {
                                      setState(() {
                                        resetPasswordAccess = value;
                                      });
                                    },
                                  ),
                                ]),
                          ),
                        ]),
                  ],
                ),
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
                "Update",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  Navigator.of(context, rootNavigator: true).pop();
                  service
                      .updatePrivilege(
                    privilegeService.Privilege()
                      ..createUser = createAccess
                      ..viewAllUsers = viewAccess
                      ..id = privilege.id
                      ..blockUser = blockAccess
                      ..deleteUser = deleteAccess
                      ..managePrivileges = managePrivileges
                      ..sendResetPasswordEmail = resetPasswordAccess
                      ..name = _nameController.text,
                  )
                      .catchError((error) {
                    CustomFlushbarError(
                      title: "Something went worng",
                      body:
                          "We could not update the privilege. Please try again later",
                      context: context,
                    ).getFlushbar().show(context);
                  }).then((value) {
                    CustomFlushbarSuccess(
                            title: "Success",
                            body:
                                "We have successfully update the privilege!",
                            context: context)
                        .getFlushbar()
                        .show(context);
                    onUpdate();
                  });
                }
              },
            ),
          ]);
    });
  }
}
