import 'package:flutter/material.dart';
import 'package:hqs_desktop/constants/constants.dart';
import 'package:hqs_desktop/service/hqs_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hqs_desktop/screens/home/widgets/custom_text_form_field.dart';
import 'package:flushbar/flushbar.dart';

class ProfilePasswordCard extends StatefulWidget {
  final HqsService service;
  final double profileImageRadius;

  ProfilePasswordCard(
      {@required this.service, @required this.profileImageRadius})
      : assert(service != null),
        assert(profileImageRadius != null);

  @override
  _ProfilePasswordCardState createState() => _ProfilePasswordCardState(
      service: service, profileImageRadius: profileImageRadius);
}

class _ProfilePasswordCardState extends State<ProfilePasswordCard> {
  // form controllers
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _repeatedPasswordController = TextEditingController();

  // constructor parameters
  final HqsService service;
  final double profileImageRadius;

  bool passwordLongerThanSix = false;
  bool passwordContainsUpper = false;
  bool passwordContainsLower = false;
  bool passwordContainsNumber = false;

  _ProfilePasswordCardState(
      {@required this.service, @required this.profileImageRadius}) {
    assert(service != null);
    assert(profileImageRadius != null);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: profileImageRadius / 4),
          child: Container(
              width: size.width / 2 - 32,
              child: Card(
                elevation: 4,
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(cardBorderRadius),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(40),
                  child: Column(children: [
                    Align(
                      child: Text(
                        "Edit Password",
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                      alignment: Alignment.topLeft,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 8),
                              child: CustomTextFormField(
                                defaultBorderColor: Colors.grey[400],
                                controller: _oldPasswordController,
                                hintText: 'Old Password',
                                labelText: 'Old Password',
                                validator: (value) {
                                  if (value.length < 6) {
                                    return "Please specify a valid password";
                                  }
                                  return null;
                                },
                                obscure: false,
                              ),
                            ),
                            SizedBox(height: 45),
                            CustomTextFormField(
                              defaultBorderColor: Colors.grey[400],
                              controller: _newPasswordController,
                              onChange: (value) {
                                setState(() {
                                  // todo on backslash password don't update correct when obscure text is true... wait for fix and set to false for now
                                  passwordContainsLower =
                                      RegExp(r"[a-z]+").hasMatch(value);
                                  passwordContainsUpper =
                                      RegExp(r"[A-Z]+").hasMatch(value);
                                  passwordContainsNumber =
                                      RegExp(r"[0-9]+").hasMatch(value);
                                  passwordLongerThanSix = value.length >= 6;
                                });
                              },
                              validator: (value) {
                                if (!passwordContainsLower &&
                                    !passwordContainsUpper &&
                                    !passwordContainsNumber &&
                                    !passwordLongerThanSix) {
                                  return "Please specify a valid password";
                                }
                                return null;
                              },
                              obscure: false,
                              hintText: "New Password",
                              labelText: "New Password",
                            ),
                            SizedBox(height: 45),
                            CustomTextFormField(
                              defaultBorderColor: Colors.grey[400],
                              controller: _repeatedPasswordController,
                              hintText: "Repeat New password",
                              labelText: "Repeat New password",
                              obscure: false,
                              validator: (value) {
                                if (value != _newPasswordController.text) {
                                  return "The two passwords don't match";
                                }
                                return null;
                              },
                            ),
                          ],
                        )),
                    SizedBox(
                      height: 16,
                    ),
                    Align(
                        alignment: Alignment.bottomRight,
                        child: SizedBox(
                            width: 200,
                            height: 50.0,
                            child: RaisedButton(
                              color: kPrimaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(cardBorderRadius),
                              ),
                              child: Text("Update Password"),
                              textColor: Colors.white,
                              onPressed: () async => {
                                if (_formKey.currentState.validate())
                                  {
                                    service
                                        .updateCurrentUserPassword(
                                            context,
                                            _oldPasswordController.text,
                                            _newPasswordController.text)
                                        .catchError((error) {
                                      _oldPasswordController.text = "";
                                      _newPasswordController.text = "";
                                      _repeatedPasswordController.text = "";
                                      setState(() {
                                        passwordContainsLower = false;
                                        passwordContainsNumber = false;
                                        passwordContainsUpper = false;
                                        passwordLongerThanSix = false;
                                      });
                                      Flushbar(
                                        title: "Something went wrong",
                                        maxWidth: 800,
                                        icon: Icon(
                                          Icons.error_outline,
                                          size: 28.0,
                                          color: Colors.red[600],
                                        ),
                                        flushbarPosition: FlushbarPosition.TOP,
                                        message:
                                            "We could not update your password. Please make sure that the current password you specified is correct and that you have a valid wifi connection.",
                                        margin: EdgeInsets.all(8),
                                        borderRadius: 8,
                                        duration: Duration(seconds: 5),
                                      )..show(context);
                                    }).then((value) {
                                      if (value != null) {
                                        _oldPasswordController.text = "";
                                        _newPasswordController.text = "";
                                        _repeatedPasswordController.text = "";
                                        setState(() {
                                          passwordContainsLower = false;
                                          passwordContainsNumber = false;
                                          passwordContainsUpper = false;
                                          passwordLongerThanSix = false;
                                        });
                                        Flushbar(
                                          title:
                                              "Password successfully updated",
                                          maxWidth: 800,
                                          icon: Icon(
                                            Icons.check_circle,
                                            size: 28.0,
                                            color: Colors.green,
                                          ),
                                          flushbarPosition:
                                              FlushbarPosition.TOP,
                                          message:
                                              "Your password has successfully been updated.",
                                          margin: EdgeInsets.all(8),
                                          borderRadius: 8,
                                          duration: Duration(seconds: 5),
                                        )..show(context);
                                      }
                                    })
                                  }
                              },
                            ))),
                  ]),
                ),
              )),
        ),
        Padding(
            padding: EdgeInsets.only(top: profileImageRadius / 4, left: 32),
            child: Container(
                width: size.width / 2 - 32,
                height: 250,
                child: Card(
                    elevation: 4,
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(cardBorderRadius),
                      ),
                    ),
                    color: kDarkBlue,
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Password Rules",
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: kBlueInfo,
                              ),
                            ),
                            SizedBox(height: 18),
                            Text(
                              "1. Needs to be at least 6 characters long  " +
                                  (passwordLongerThanSix ? "✅" : "❌"),
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 18),
                            Text(
                              "2. Needs to contain at least one uppercase letter  " +
                                  (passwordContainsUpper ? "✅" : "❌"),
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 18),
                            Text(
                              "2. Needs to contain at least one lowercase letter  " +
                                  (passwordContainsLower ? "✅" : "❌"),
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 18),
                            Text(
                              " 3. Needs to contain at least one number  " +
                                  (passwordContainsNumber ? "✅" : "❌"),
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            ),
                          ]),
                    )))),
      ],
    );
  }
}
