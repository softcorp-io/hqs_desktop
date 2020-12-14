import 'package:flutter/material.dart';
import 'package:flushbar/flushbar.dart';
import 'package:hqs_desktop/generated/hqs-user-service/proto/hqs-user-service.pb.dart';
import 'package:hqs_desktop/home/screens/admin_users/constants/text.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hqs_desktop/constants/constants.dart';
import 'package:hqs_desktop/service/hqs_service.dart';

class BlockUserDialog extends StatelessWidget {
  final HqsService service;
  final User user;
  final Function onUpdate;
  final BuildContext buildContext;

  BlockUserDialog(
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
        userSourceBlockDialogTitle(user),
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
              userSourceBlockDialogTextOne,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: Colors.black,
              ),
            ),
            Text(
              userSourceBlockDialogTextTwo,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: Colors.black,
              ),
            ),
            Text(
              userSourceBlockDialogTextThree,
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
            userSourceBlockDialogCancelBtnText,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: Colors.red,
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
              color: kPrimaryColor,
            ),
          ),
          onPressed: () {
            Navigator.of(buildContext, rootNavigator: true).pop();
            service.blockUser(user)
              ..catchError((error) {
                Flushbar(
                  title: userSourceBlockDialogExceptionTitle,
                  maxWidth: 800,
                  icon: Icon(
                    Icons.error_outline,
                    size: 28.0,
                    color: Colors.red[600],
                  ),
                  flushbarPosition: FlushbarPosition.TOP,
                  message: userSourceBlockDialogExceptionText(user, error),
                  margin: EdgeInsets.all(8),
                  borderRadius: 8,
                  duration: Duration(seconds: 5),
                )..show(buildContext);
              }).then((value) {
                onUpdate();
                Flushbar(
                  title: userSourceBlockDialogSuccessTitle(user),
                  maxWidth: 800,
                  icon: Icon(
                    Icons.check_circle,
                    size: 28.0,
                    color: Colors.green,
                  ),
                  flushbarPosition: FlushbarPosition.TOP,
                  message: userSourceBlockDialogSuccessText(user),
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
