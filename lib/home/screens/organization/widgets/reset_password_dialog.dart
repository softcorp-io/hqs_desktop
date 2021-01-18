import 'package:flutter/material.dart';
import 'package:dart_hqs/hqs_user_service.pb.dart';
import 'package:hqs_desktop/home/screens/organization/constants/text.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hqs_desktop/home/widgets/custom_flushbar_error.dart';
import 'package:hqs_desktop/home/widgets/custom_flushbar_success.dart';
import 'package:hqs_desktop/service/hqs_service.dart';

class ResetPasswordDialog extends StatelessWidget {
  final HqsService service;
  final User user;
  final Function onUpdate;
  final BuildContext buildContext;

  ResetPasswordDialog(
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
    return AlertDialog(
      title: Text(
        userSourceResetPasswordDialogTitle(user),
        style: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(
              userSourceResetPasswordDialogTextOne(user),
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
            ),
            Text(
              userSourceResetPasswordDialogTextTwo(user),
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
            ),
            Text(
              userSourceResetPasswordDialogTextThree,
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
            userSourceResetPasswordDialogCancelBtnText,
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
            userSourceResetPasswordDialogBlockBtnText,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: Theme.of(context).primaryColor,
            ),
          ),
          onPressed: () {
            Navigator.of(buildContext, rootNavigator: true).pop();
            service.sendResetPassordEmail(user)
              ..catchError((error) {
                CustomFlushbarError(
                        title: userSourceResetPasswordDialogExceptionTitle,
                        body: userSourceResetPasswordDialogExceptionText(
                            user, error),
                        context: context)
                    .getFlushbar()
                    .show(context);
              }).then((value) {
                onUpdate();
                CustomFlushbarSuccess(
                        title: userSourceResetPassworDialogSuccessTitle,
                        body: userSourceResetPasswordDialogSuccessText(user),
                        context: context)
                    .getFlushbar()
                    .show(Navigator.of(buildContext, rootNavigator: true)
                        .context);
                return value;
              });
          },
        ),
      ],
    );
  }
}
