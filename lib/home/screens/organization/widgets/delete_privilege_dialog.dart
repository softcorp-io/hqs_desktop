import 'package:dart_hqs/hqs_privileges_service.pb.dart';
import 'package:flutter/material.dart';
import 'package:hqs_desktop/home/screens/organization/constants/text.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hqs_desktop/home/widgets/custom_flushbar_error.dart';
import 'package:hqs_desktop/home/widgets/custom_flushbar_success.dart';
import 'package:hqs_desktop/service/hqs_service.dart';
import 'package:dart_hqs/hqs_privilege_service.pbgrpc.dart' as privilegeService;
import 'package:hqs_desktop/theme/constants.dart';

class DeletePrivilegeDialog extends StatelessWidget {
  final HqsService service;
  final privilegeService.Privilege privilege;
  final Function onUpdate;
  final BuildContext buildContext;

  DeletePrivilegeDialog(
      {@required this.service,
      @required this.privilege,
      @required this.onUpdate,
      @required this.buildContext})
      : assert(service != null),
        assert(onUpdate != null),
        assert(buildContext != null),
        assert(privilege != null);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "Are you sure you want to delete ${privilege.name}",
        style: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(
              "After deleting a privilege, all users with that",
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
            ),
            Text(
              "privilege will get the default privilege.",
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
            ),
            Text(
              "Their privilege can updated afterwards.",
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.normal,
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
              color: dangerColor,
            ),
          ),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
        ),
        TextButton(
          child: Text(
            "Delete",
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: Theme.of(context).primaryColor,
            ),
          ),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
            service.deletePrivilege(privilege).catchError((error) {
              CustomFlushbarError(
                      title: "Could not delete privilege",
                      body:
                          "We could not delete the requested privilege. Please try again later.",
                      context: context)
                  .getFlushbar()
                  .show(context);
            }).then((value) {
              onUpdate();
              CustomFlushbarSuccess(
                      title: "Successfully delete privilege",
                      body: "We successfully deleted the requested privilege.",
                      context: context)
                  .getFlushbar()
                  .show(
                      Navigator.of(buildContext, rootNavigator: true).context);
              return value;
            });
          },
        ),
      ],
    );
  }
}
