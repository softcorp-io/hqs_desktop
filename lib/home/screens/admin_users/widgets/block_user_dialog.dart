import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:dart_hqs/hqs_user_service.pb.dart';
import 'package:hqs_desktop/home/screens/admin_users/constants/text.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hqs_desktop/constants/constants.dart';
import 'package:hqs_desktop/home/widgets/custom_flushbar_error.dart';
import 'package:hqs_desktop/service/hqs_user_service.dart';
import 'package:hqs_desktop/theme/theme.dart';

class BlockUserDialog extends StatelessWidget {
  final HqsService service;
  final User user;
  final Function onUpdate;
  final BuildContext buildContext;
  final HqsTheme theme;

  BlockUserDialog(
      {@required this.service,
      @required this.user,
      @required this.theme,
      @required this.onUpdate,
      @required this.buildContext})
      : assert(service != null),
        assert(onUpdate != null),
        assert(theme != null),
        assert(buildContext != null),
        assert(user != null);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: theme.cardDefaultColor(),
      title: Text(
        userSourceBlockDialogTitle(user),
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
              userSourceBlockDialogTextOne,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: theme.textColor(),
              ),
            ),
            Text(
              userSourceBlockDialogTextTwo,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: theme.textColor(),
              ),
            ),
            Text(
              userSourceBlockDialogTextThree,
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
            userSourceBlockDialogCancelBtnText,
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
            userSourceBlockDialogBlockBtnText(user),
            style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: theme.primaryColor()),
          ),
          onPressed: () {
            Navigator.of(buildContext, rootNavigator: true).pop();
            service.blockUser(user)
              ..catchError((error) {
                CustomFlushbarError(
                        title: userSourceBlockDialogExceptionTitle,
                        body: userSourceBlockDialogExceptionText(user, error),
                        theme: theme)
                    .getFlushbar()
                    .show(buildContext);
              }).then((value) {
                onUpdate();
                CustomFlushbarError(
                        title: userSourceBlockDialogSuccessTitle(user),
                        body: userSourceBlockDialogSuccessText(user),
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