import 'package:flutter/material.dart';
import 'package:flushbar/flushbar.dart';
import 'package:hqs_desktop/generated/hqs-user-service/proto/hqs-user-service.pb.dart';
import 'package:hqs_desktop/home/screens/admin_users/constants/text.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hqs_desktop/constants/constants.dart';
import 'package:hqs_desktop/service/hqs_service.dart';

class DeleteUserDialog extends StatelessWidget {
  final HqsService service;
  final User user;
  final Function onUpdate;
  final BuildContext buildContext;

  DeleteUserDialog(
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
        userSourceDeleteUserDialogTitle(user),
        style: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.black,
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
                color: Colors.black,
              ),
            ),
            Text(
              userSourceDeleteUserDialogTextTwo,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: Colors.black,
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
              color: Colors.red,
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
              color: kPrimaryColor,
            ),
          ),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
            service.deleteUser(user.id)
              ..catchError((error) {
                Flushbar(
                  title: userSourceDeleteExceptionTitle,
                  maxWidth: 800,
                  icon: Icon(
                    Icons.error_outline,
                    size: 28.0,
                    color: Colors.red[600],
                  ),
                  flushbarPosition: FlushbarPosition.TOP,
                  message: userSourceDeleteExceptionText(user),
                  margin: EdgeInsets.all(8),
                  borderRadius: 8,
                  duration: Duration(seconds: 5),
                )..show(context);
              }).then((value) {
                onUpdate();
                Flushbar(
                  title: userSourceDeleteSuccessTitle(user),
                  maxWidth: 800,
                  icon: Icon(
                    Icons.check_circle,
                    size: 28.0,
                    color: Colors.green,
                  ),
                  flushbarPosition: FlushbarPosition.TOP,
                  message: userSourceDeleteSuccessText(user),
                  margin: EdgeInsets.all(8),
                  borderRadius: 8,
                  duration: Duration(seconds: 5),
                )..show(Navigator.of(buildContext, rootNavigator: true).context);
                return value;
              });
          },
        ),
      ],
    );
  }
}
