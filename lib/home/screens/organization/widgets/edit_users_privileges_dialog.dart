import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dart_hqs/hqs_user_service.pb.dart';
import 'package:hqs_desktop/home/widgets/custom_dropdown_form_field.dart';
import 'package:hqs_desktop/home/widgets/custom_flushbar_error.dart';
import 'package:hqs_desktop/home/widgets/custom_flushbar_success.dart';
import 'package:hqs_desktop/service/hqs_service.dart';
import 'package:dart_hqs/hqs_privilege_service.pbgrpc.dart' as privilegeService;

class EditUsersPrivilegesDialog extends StatelessWidget {
  final HqsService service;
  final List<privilegeService.Privilege> privileges;
  final User user;
  final Function onUpdate;
  String chosenPrivilege;
  Token signupToken;

  EditUsersPrivilegesDialog(
      {@required this.service,
      @required this.privileges,
      @required this.user,
      @required this.onUpdate})
      : assert(service != null),
        assert(user != null),
        assert(onUpdate != null),
        assert(privileges != null) {
    chosenPrivilege = privileges
        .firstWhere((privilege) => privilege.id == user.privilegeID)
        .id;
  }

  List<DropdownMenuItem> getPrivilegeDropdownMenu(
      List<privilegeService.Privilege> privileges) {
    List<DropdownMenuItem> items = new List<DropdownMenuItem>();
    privileges.forEach((priv) {
      items.add(DropdownMenuItem(
        child: Text(priv.name),
        value: priv.id,
      ));
    });
    return items;
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return AlertDialog(
        title: Text(
          "Edit ${user.name}'s privillege",
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Container(
          width: 600,
          height: 180,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Form(
                key: _formKey,
                child: Flexible(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Select privilege"),
                        SizedBox(
                          height: 8,
                        ),
                        CustomDromDownMenu(
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Not a valid privilege";
                            }
                            return null;
                          },
                          hintText: "Select Privilege",
                          items: getPrivilegeDropdownMenu(privileges),
                          value: chosenPrivilege,
                          onChanged: (value) {
                            setState(() {
                              chosenPrivilege = value;
                            });
                          },
                        ),
                      ]),
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
              "Update",
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: Theme.of(context).primaryColor,
              ),
            ),
            onPressed: () {
              if (_formKey.currentState.validate()) {
                service
                    .updateUsersPrivileges(
                  user.id,
                  chosenPrivilege,
                )
                    .catchError((error) {
                  CustomFlushbarError(
                          title: "Could no update users privileges",
                          body:
                              "We could not update ${user.name}'s privileges. Please try again later.",
                          context: context)
                      .getFlushbar()
                      .show(context);
                }).then(
                  (value) {
                    onUpdate();
                    CustomFlushbarSuccess(
                            title:
                                "Successfully updated ${user.name}'s privileges",
                            body:
                                "We have successfully updated ${user.name}'s privileges.",
                            context: context)
                        .getFlushbar()
                        .show(
                            Navigator.of(context, rootNavigator: true).context);
                  },
                );
              }
              Navigator.of(context, rootNavigator: true).pop();
            },
          ),
        ],
      );
    });
  }
}
