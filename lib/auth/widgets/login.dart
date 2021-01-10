import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hqs_desktop/auth/constants/text.dart';
import 'package:hqs_desktop/constants/constants.dart';
import 'package:hqs_desktop/home/widgets/custom_flushbar_error.dart';
import 'package:hqs_desktop/home/widgets/custom_text_form_field.dart';
import 'package:hqs_desktop/service/hqs_user_service.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:hqs_desktop/theme/theme.dart';

class LogIn extends StatefulWidget {
  final HqsService service;
  final Function onLogIn;
  final HqsTheme theme;

  LogIn({@required this.service, @required this.onLogIn, @required this.theme})
      : assert(HqsService != null),
        assert(theme != null),
        assert(onLogIn != null);

  @override
  _LogInState createState() =>
      _LogInState(service: service, onLogIn: onLogIn, theme: theme);
}

class _LogInState extends State<LogIn> {
  final HqsService service;
  final Function onLogIn;
  final HqsTheme theme;

  _LogInState(
      {@required this.service, @required this.onLogIn, @required this.theme})
      : assert(HqsService != null),
        assert(theme != null),
        assert(onLogIn != null);

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final _formKey = GlobalKey<FormState>();

    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.all(size.height > 770
              ? 64
              : size.height > 670
                  ? 32
                  : 16),
          child: Center(
            child: Card(
              color: Colors.transparent,
              elevation: 4,
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(cardBorderRadius),
                ),
              ),
              child: Container(
                height: size.height * 0.7,
                width: 600,
                color: theme.cardDefaultColor(),
                child: Center(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(40),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            signinTitle,
                            style: GoogleFonts.poppins(
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                              color: theme.titleColor(),
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Container(
                            width: 30,
                            child: Divider(
                              color: theme.primaryColor(),
                              thickness: 2,
                            ),
                          ),
                          SizedBox(
                            height: 18,
                          ),
                          Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                CustomTextFormField(
                                  maxLength: 50,
                                  minLines: 1,
                                  maxLines: 1,
                                  keyboardType: TextInputType.emailAddress,
                                    controller: _emailController,
                                    focusNode: FocusNode(),
                                    validator: (value) {
                                      var validEmail = RegExp(
                                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                          .hasMatch(value);
                                      if (!validEmail) {
                                        return emailValidationText;
                                      }
                                      return null;
                                    },
                                    hintText: emailHintText,
                                    labelText: emailLabelText,
                                    theme: theme,
                                    icon: Icons.person,
                                    obscure: false),
                                Padding(
                                  padding: EdgeInsets.all(10),
                                ),
                                CustomTextFormField(
                                  maxLength: 50,
                                  minLines: 1,
                                  maxLines: 1,
                                  keyboardType: TextInputType.text,
                                    controller: _passwordController,
                                    icon: Icons.lock_outline,
                                    focusNode: FocusNode(),
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return passwordValidationText;
                                      }
                                      return null;
                                    },
                                    hintText: passwordHintText,
                                    labelText: passwordLabelText,
                                    theme: theme,
                                    obscure: true),
                                Padding(
                                  padding: EdgeInsets.all(60),
                                ),
                                SizedBox(
                                    child: RaisedButton(
                                  shape: StadiumBorder(),
                                  padding: EdgeInsets.all(0.0),
                                  textColor: theme.buttonTextColor(),
                                  onPressed: () async => {
                                    if (_formKey.currentState.validate())
                                      {
                                        service
                                            .authenticate(
                                                context,
                                                _emailController.text,
                                                _passwordController.text)
                                            .catchError((error) {
                                          CustomFlushbarError(
                                                  title:
                                                      authExceptionResponseTitle,
                                                  body:
                                                      authExceptionResponseText,
                                                  theme: theme)
                                              .getFlushbar()
                                                ..show(context);
                                          _emailController.text = "";
                                          _passwordController.text = "";
                                        }).then((token) => {
                                                  if (token.token == "")
                                                    {
                                                      _emailController.text =
                                                          "",
                                                      _passwordController.text =
                                                          "",
                                                    }
                                                  else
                                                    {
                                                      // User is allowed to log in
                                                      onLogIn(),
                                                    }
                                                }),
                                      }
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    height: 50.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                          buttonBorderRadius),
                                      gradient: LinearGradient(
                                          colors: theme.defaultGradientColor()),
                                    ),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        submitButtonText,
                                        style: TextStyle(fontSize: 15.0),
                                      ),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 70.0, vertical: 15.0),
                                  ),
                                )),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}