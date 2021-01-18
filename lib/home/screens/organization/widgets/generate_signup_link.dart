import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hqs_desktop/constants/constants.dart';
import 'package:dart_hqs/hqs_user_service.pb.dart';
import 'package:hqs_desktop/home/screens/organization/constants/text.dart';
import 'package:hqs_desktop/service/hqs_service.dart';
import 'package:hqs_desktop/theme/constants.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';

class GenerateSignupTokenDialog extends StatefulWidget {
  final HqsService service;
  GenerateSignupTokenDialog({@required this.service}) : assert(service != null);

  @override
  State<StatefulWidget> createState() {
    return _GenerateSignupTokenDialogState(service: service);
  }
}

class _GenerateSignupTokenDialogState extends State<GenerateSignupTokenDialog> {
  final HqsService service;
  Future<Token> futureToken;
  Token signupToken;

  _GenerateSignupTokenDialogState({@required this.service})
      : assert(service != null) {
    futureToken = service.generateSignupToken().then((token) {
      setState(() {
        copyButtonState = ButtonState.idle;
      });
      signupToken = token;
      return token;
    });
  }

  ButtonState copyButtonState = ButtonState.loading;
  Widget buildCopyButton() {
    return ProgressButton(
      stateWidgets: {
        ButtonState.idle: Text(
          "Click To Copy",
          style: TextStyle(color: Colors.white),
        ),
        ButtonState.loading: Text(
          "Loading",
          style: TextStyle(color: Colors.white),
        ),
        ButtonState.fail: Text(
          "Failed",
          style: TextStyle(color: Colors.white),
        ),
        ButtonState.success: Text(
          "Copied",
          style: TextStyle(color: Colors.white),
        )
      },
      stateColors: {
        ButtonState.idle: primaryColor,
        ButtonState.loading: waitColor,
        ButtonState.fail: dangerColor,
        ButtonState.success: successColor,
      },
      padding: EdgeInsets.all(12),
      onPressed: onPressedCopyButton,
      state: copyButtonState,
      maxWidth: 150.0,
      height: 50.0,
      radius: buttonBorderRadius,
    );
  }

  void onPressedCopyButton() {
    if (copyButtonState == ButtonState.idle) {
      setState(() {
        copyButtonState = ButtonState.loading;
      });
      FlutterClipboard.copy(signupToken.url + signupToken.token)
          .catchError((error) {
        setState(() {
          copyButtonState = ButtonState.fail;
        });
      }).then((value) {
        setState(() {
          copyButtonState = ButtonState.success;
        });
        Future.delayed(Duration(milliseconds: 2000), () {
          setState(() {
            copyButtonState = ButtonState.idle;
          });
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return AlertDialog(
        title: Text(
          "Generate Signup Link",
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Container(
          width: 700,
          height: 250,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 800,
                child: Text(
                  "Anyone with the URL below will be able to create a profile in your organization. Notice this link can only be used once and is only valid for 24 hours. The user will be given default privileges.",
                ),
              ),
              SizedBox(height: 60),
              Row(
                children: [
                  Container(
                    width: 500,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(cardBorderRadius),
                    ),
                    child: FutureBuilder<Token>(
                        future: futureToken,
                        builder: (BuildContext context,
                            AsyncSnapshot<Token> snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.done:
                              return Padding(
                                padding: EdgeInsets.all(10),
                                child: Container(
                                  width: 500,
                                  height: 50,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Text(
                                      signupToken.url + signupToken.token,
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                      maxLines: 1,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              );
                            default:
                              return Container();
                          }
                        }),
                  ),
                  Spacer(),
                  buildCopyButton(),
                ],
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              generateSignUpLinkCloseButton,
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
        ],
      );
    });
  }
}
