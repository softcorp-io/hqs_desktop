import 'package:flutter/material.dart';
import 'package:hqs_desktop/constants/constants.dart';
import 'package:hqs_desktop/home/screens/profile/constants/constants.dart';
import 'package:hqs_desktop/home/screens/profile/constants/text.dart';
import 'package:hqs_desktop/service/hqs_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hqs_desktop/home/widgets/custom_text_form_field.dart';
import 'package:flushbar/flushbar.dart';

class ProfilePasswordForm extends StatefulWidget {
  final HqsService service;

  ProfilePasswordForm({
    @required this.service,
  }) : assert(service != null);
  @override
  _ProfilePasswordFormState createState() =>
      _ProfilePasswordFormState(service: service);
}

class _ProfilePasswordFormState extends State<ProfilePasswordForm> {
  // form controllers
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _repeatedPasswordController = TextEditingController();

  // constructor parameters
  final HqsService service;

  bool passwordLongerThanSix = false;
  bool passwordContainsUpper = false;
  bool passwordContainsLower = false;
  bool passwordContainsNumber = false;

  _ProfilePasswordFormState({@required this.service}) {
    assert(service != null);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double screenSplitSize =
        size.width / (size.width > screenSplit ? windowSplit : 1) -
            railSize +
            8;
    return Wrap(
      textDirection: TextDirection.rtl,
      alignment: WrapAlignment.spaceAround,
      direction: Axis.horizontal,
      runSpacing: cardPadding / 2,
      children: <Widget>[
        Container(
            width: screenSplitSize,
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
                          passwordRuleTitle,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: kBlueInfo,
                          ),
                        ),
                        SizedBox(height: 18),
                        Text(
                         passwordRuleOne +
                              (passwordLongerThanSix ? passwordValid : passwordInvalid),
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 18),
                        Text(
                          passwordRuleTwo +
                              (passwordContainsUpper ? passwordValid : passwordInvalid),
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 18),
                        Text(
                         passwordRuleThree +
                              (passwordContainsLower ? passwordValid : passwordInvalid),
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 18),
                        Text(
                          passwordRuleFour +
                              (passwordContainsNumber ? passwordValid : passwordInvalid),
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                      ]),
                ))),
        SizedBox(width: cardPadding),
        Container(
            width: screenSplitSize,
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
                      passwordFormTitle,
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
                              hintText: passwordFormOldPasswordHint,
                              labelText: passwordFormOldPasswordText,
                              validator: (value) {
                                if (value.length < 6) {
                                  return passwordFormOldPasswordValidator;
                                }
                                return null;
                              },
                              obscure: true,
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
                                return passwordFormNewPasswordValidator;
                              }
                              return null;
                            },
                            obscure: true,
                            hintText: passwordFormNewPasswordHint,
                            labelText:passwordFormNewPasswordText,
                          ),
                          SizedBox(height: 45),
                          CustomTextFormField(
                            defaultBorderColor: Colors.grey[400],
                            controller: _repeatedPasswordController,
                            hintText: passwordFormRepeatPasswordHint,
                            labelText: passwordFormRepeatPasswordText,
                            obscure: true,
                            validator: (value) {
                              if (value != _newPasswordController.text) {
                                return passwordFormRepeatPasswordValidator;
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
                            child: Text(passwordFormUpdateBtnText),
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
                                      title: passwordFormExceptionTitle,
                                      maxWidth: 800,
                                      icon: Icon(
                                        Icons.error_outline,
                                        size: 28.0,
                                        color: Colors.red[600],
                                      ),
                                      flushbarPosition: FlushbarPosition.TOP,
                                      message:
                                          passwordFormExceptionText,
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
                                        title: passwordFormSuccessTitle,
                                        maxWidth: 800,
                                        icon: Icon(
                                          Icons.check_circle,
                                          size: 28.0,
                                          color: Colors.green,
                                        ),
                                        flushbarPosition: FlushbarPosition.TOP,
                                        message:
                                            passwordFormSuccessText,
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
      ],
    );
  }
}
