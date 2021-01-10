import 'package:flutter/material.dart';
import 'package:dart_hqs/hqs_user_service.pb.dart';
import 'package:hqs_desktop/home/screens/admin_users/constants/text.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hqs_desktop/home/widgets/custom_flushbar_error.dart';
import 'package:hqs_desktop/home/widgets/custom_flushbar_success.dart';
import 'package:hqs_desktop/service/hqs_user_service.dart';
import 'package:hqs_desktop/theme/theme.dart';

class DeleteUserDialog extends StatelessWidget {
  final HqsService service;
  final User user;
  final Function onUpdate;
  final BuildContext buildContext;
  final HqsTheme theme;

  DeleteUserDialog(
      {@required this.service,
      @required this.user,
      @required this.onUpdate,
      @required this.theme,
      @required this.buildContext})
      : assert(service != null),
        assert(theme != null),
        assert(onUpdate != null),
        assert(buildContext != null),
        assert(user != null);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: theme.cardDefaultColor(),
      title: Text(
        userSourceDeleteUserDialogTitle(user),
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
              userSourceDeleteUserDialogTextOne,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: theme.textColor(),
              ),
            ),
            Text(
              userSourceDeleteUserDialogTextTwo,
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
            userSourceDeleteUserDialogCloseBtnText,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: theme.dangerColor(),
            ),
          ),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
        ),
        TextButton(
          child: Text(
            userSourceDeleteUserDialogDeleteBtnText,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: theme.primaryColor(),
            ),
          ),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
            service.deleteUser(user.id)
              ..catchError((error) {
                CustomFlushbarError(
                        title: userSourceDeleteExceptionTitle,
                        body: userSourceDeleteExceptionText(user),
                        theme: theme)
                    .getFlushbar()
                    .show(context);
              }).then((value) {
                onUpdate();
                CustomFlushbarSuccess(
                        title: userSourceDeleteSuccessTitle(user),
                        body: userSourceDeleteSuccessText(user),
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
