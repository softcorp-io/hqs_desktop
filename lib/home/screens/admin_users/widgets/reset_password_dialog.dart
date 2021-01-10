import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:dart_hqs/hqs_user_service.pb.dart';
import 'package:hqs_desktop/home/screens/admin_users/constants/text.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hqs_desktop/constants/constants.dart';
import 'package:hqs_desktop/home/widgets/custom_flushbar_error.dart';
import 'package:hqs_desktop/home/widgets/custom_flushbar_success.dart';
import 'package:hqs_desktop/service/hqs_user_service.dart';
import 'package:hqs_desktop/theme/theme.dart';

class ResetPasswordDialog extends StatelessWidget {
  final HqsService service;
  final User user;
  final Function onUpdate;
  final BuildContext buildContext;
  final HqsTheme theme;

  ResetPasswordDialog(
      {@required this.service,
      @required this.user,
      @required this.onUpdate,
      @required this.theme,
      @required this.buildContext})
      : assert(service != null),
        assert(onUpdate != null),
        assert(theme != null),
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
          color: theme.titleColor(),
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
                color: theme.textColor(),
              ),
            ),
            Text(
              userSourceResetPasswordDialogTextTwo(user),
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: theme.textColor(),
              ),
            ),
            Text(
              userSourceResetPasswordDialogTextThree,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: theme.textColor(),
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
              color: theme.dangerColor(),
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
              color: theme.primaryColor(),
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
                        theme: theme)
                    .getFlushbar()
                    .show(context);
              }).then((value) {
                onUpdate();
                CustomFlushbarSuccess(
                        title: userSourceResetPassworDialogSuccessTitle,
                        body: userSourceResetPasswordDialogSuccessText(user),
                        theme: theme)
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
