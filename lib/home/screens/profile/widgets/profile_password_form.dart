import 'package:flutter/material.dart';
import 'package:hqs_desktop/constants/constants.dart';
import 'package:hqs_desktop/home/screens/profile/constants/constants.dart';
import 'package:hqs_desktop/home/screens/profile/constants/text.dart';
import 'package:hqs_desktop/home/widgets/custom_flushbar_error.dart';
import 'package:hqs_desktop/home/widgets/custom_flushbar_success.dart';
import 'package:hqs_desktop/service/hqs_user_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hqs_desktop/home/widgets/custom_text_form_field.dart';
import 'package:hqs_desktop/theme/theme.dart';

class ProfilePasswordForm extends StatefulWidget {
  final HqsService service;
  final HqsTheme theme;
  ProfilePasswordForm({
    @required this.service,
    @required this.theme,
  })  : assert(service != null),
        assert(theme != null);
  @override
  _ProfilePasswordFormState createState() =>
      _ProfilePasswordFormState(service: service, theme: theme);
}

class _ProfilePasswordFormState extends State<ProfilePasswordForm> {
  // form controllers
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _repeatedPasswordController = TextEditingController();

  // constructor parameters
  final HqsService service;
  final HqsTheme theme;

  bool passwordLongerThanSix = false;
  bool passwordContainsUpper = false;
  bool passwordContainsLower = false;
  bool passwordContainsNumber = false;

  _ProfilePasswordFormState({@required this.service, @required this.theme}) {
    assert(service != null);
    assert(theme != null);
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
                color: theme.cardDefaultColor(),
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
                              color: theme.titleColor()),
                        ),
                        SizedBox(height: 18),
                        Text(
                          passwordRuleOne +
                              (passwordLongerThanSix
                                  ? passwordValid
                                  : passwordInvalid),
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: theme.textColor(),
                          ),
                        ),
                        SizedBox(height: 18),
                        Text(
                          passwordRuleTwo +
                              (passwordContainsUpper
                                  ? passwordValid
                                  : passwordInvalid),
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: theme.textColor(),
                          ),
                        ),
                        SizedBox(height: 18),
                        Text(
                          passwordRuleThree +
                              (passwordContainsLower
                                  ? passwordValid
                                  : passwordInvalid),
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: theme.textColor(),
                          ),
                        ),
                        SizedBox(height: 18),
                        Text(
                          passwordRuleFour +
                              (passwordContainsNumber
                                  ? passwordValid
                                  : passwordInvalid),
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: theme.textColor(),
                          ),
                        ),
                      ]),
                ))),
        SizedBox(width: cardPadding),
        Container(
            width: screenSplitSize,
            child: Card(
              color: theme.cardDefaultColor(),
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
                        color: theme.titleColor(),
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
                              maxLength: 50,
                              minLines: 1,
                              maxLines: 1,
                              keyboardType: TextInputType.text,
                              focusNode: FocusNode(),
                              theme: theme,
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
                            maxLength: 50,
                            minLines: 1,
                            maxLines: 1,
                            keyboardType: TextInputType.text,
                            focusNode: FocusNode(),
                            theme: theme,
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
                            labelText: passwordFormNewPasswordText,
                          ),
                          SizedBox(height: 45),
                          CustomTextFormField(
                            maxLength: 50,
                            minLines: 1,
                            maxLines: 1,
                            keyboardType: TextInputType.text,
                            focusNode: FocusNode(),
                            theme: theme,
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
                            color: theme.primaryColor(),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(cardBorderRadius),
                            ),
                            child: Text(passwordFormUpdateBtnText),
                            textColor: theme.buttonTextColor(),
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
                                    CustomFlushbarError(
                                            title: passwordFormExceptionTitle,
                                            body: passwordFormExceptionText,
                                            theme: theme)
                                        .getFlushbar()
                                        .show(context);
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
                                      CustomFlushbarSuccess(
                                              title: passwordFormSuccessTitle,
                                              body: passwordFormSuccessText,
                                              theme: theme)
                                          .getFlushbar()
                                          .show(context);
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
