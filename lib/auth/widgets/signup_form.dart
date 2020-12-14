import 'package:flutter/material.dart';
import 'package:hqs_desktop/auth/constants/text.dart';
import 'package:hqs_desktop/constants/constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hqs_desktop/service/hqs_service.dart';
import 'package:flushbar/flushbar.dart';

class SignUp extends StatefulWidget {
  final Function onLogInSelected;
  final HqsService service;

  SignUp({@required this.onLogInSelected, @required this.service})
      : assert(service != null),
        assert(onLogInSelected != null);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool gender = false;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _repeatPasswordController = TextEditingController();
  final _tokenController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final _formKey = GlobalKey<FormState>();

    return Padding(
      padding: EdgeInsets.all(size.height > 770
          ? 64
          : size.height > 670
              ? 32
              : 16),
      child: Center(
        child: Card(
          clipBehavior: Clip.antiAlias,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(cardBorderRadius),
            ),
          ),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            height: size.height *
                (size.height > 770
                    ? 0.7
                    : size.height > 670
                        ? 0.8
                        : 0.9),
            width: 600,
            color: Colors.white,
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(40),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          signupTitle,
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[700],
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Container(
                          width: 30,
                          child: Divider(
                            color: kPrimaryColor,
                            thickness: 2,
                          ),
                        ),
                        SizedBox(
                          height: 32,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Flexible(
                              child: TextFormField(
                                controller: _nameController,
                                decoration: InputDecoration(
                                  hintText: nameHintText,
                                  labelText: nameLabelText,
                                  suffixIcon: Icon(
                                    Icons.person,
                                  ),
                                ),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return nameValidatorText;
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            Flexible(
                              child: TextFormField(
                                controller: _emailController,
                                decoration: InputDecoration(
                                  hintText: emailHintTextSignup,
                                  labelText: emailLabelTextSignup,
                                  suffixIcon: Icon(
                                    Icons.mail_outline,
                                  ),
                                ),
                                validator: (value) {
                                  var validEmail = RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(value);
                                  if (!validEmail) {
                                    return emailValidatorText;
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 32,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Flexible(
                              child: TextFormField(
                                obscureText: true,
                                controller: _passwordController,
                                decoration: InputDecoration(
                                  hintText: passwordHintTextSignup,
                                  labelText: passwordLabelTextSignup,
                                  suffixIcon: Icon(
                                    Icons.lock_outline,
                                  ),
                                ),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return passwordValidatorText;
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            Flexible(
                              child: TextFormField(
                                obscureText: true,
                                controller: _repeatPasswordController,
                                decoration: InputDecoration(
                                  hintText: repeatPasswordHintText,
                                  labelText: repeatPasswordLabelText,
                                  suffixIcon: Icon(
                                    Icons.repeat_one,
                                  ),
                                ),
                                validator: (value) {
                                  if (_repeatPasswordController.text !=
                                      _passwordController.text) {
                                    return repeatPasswordValidatorText;
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 32,
                        ),
                        DropdownButton(
                          hint: Text(genderDropDownHint),
                          value: gender,
                          onChanged: (value) {
                            setState(() {
                              gender = value;
                            });
                          },
                          isExpanded: true,
                          items: <DropdownMenuItem>[
                            DropdownMenuItem(
                              child: Text("Male"),
                              value: false,
                            ),
                            DropdownMenuItem(
                              child: Text("Female"),
                              value: true,
                            )
                          ],
                        ),
                        SizedBox(
                          height: 32,
                        ),
                        TextFormField(
                          controller: _tokenController,
                          decoration: InputDecoration(
                            hintText: signupTokenHintText,
                            labelText: signupTokenLabelText,
                            suffixIcon: Icon(
                              Icons.security,
                            ),
                          ),
                          validator: (value) {
                            if (value.isEmpty || value.length < 10) {
                              return signupTokenValidatorText;
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 64,
                        ),
                        SizedBox(
                          height: 32,
                        ),
                        SizedBox(
                            child: RaisedButton(
                          shape: StadiumBorder(),
                          padding: EdgeInsets.all(0.0),
                          textColor: Colors.white,
                          onPressed: () async => {
                            if (_formKey.currentState.validate())
                              {
                                widget.service
                                    .signupByToken(
                                        _nameController.text,
                                        _emailController.text,
                                        _passwordController.text,
                                        gender,
                                        _tokenController.text)
                                    .catchError((error) {
                                  Flushbar(
                                    title: signupExceptionTitle,
                                    maxWidth: 800,
                                    icon: Icon(
                                      Icons.error_outline,
                                      size: 28.0,
                                      color: Colors.red[600],
                                    ),
                                    flushbarPosition: FlushbarPosition.TOP,
                                    message: signupExceptionText,
                                    margin: EdgeInsets.all(8),
                                    borderRadius: 8,
                                    duration: Duration(seconds: 5),
                                  )..show(context);
                                }).then((value) {
                                  if (value != null) {
                                    widget.onLogInSelected();
                                    Flushbar(
                                      title: signupSuccessTitle,
                                      maxWidth: 800,
                                      icon: Icon(
                                        Icons.check_circle,
                                        size: 28.0,
                                        color: Colors.green,
                                      ),
                                      flushbarPosition: FlushbarPosition.TOP,
                                      message: signupSuccessText,
                                      margin: EdgeInsets.all(8),
                                      borderRadius: 8,
                                      duration: Duration(seconds: 5),
                                    )..show(context);
                                  }
                                })
                              }
                          },
                          child: Container(
                            width: double.infinity,
                            height: 50.0,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(buttonBorderRadius),
                              gradient: LinearGradient(
                                colors: <Color>[
                                  kBlueOne,
                                  kBlueTwo,
                                  kBlueThree,
                                ],
                              ),
                            ),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                submitSignupButtonText,
                                style: TextStyle(fontSize: 15.0),
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 70.0, vertical: 15.0),
                          ),
                        )),
                        Padding(
                          padding: EdgeInsets.all(12),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              alreadyHaveAnAccountText,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            GestureDetector(
                              onTap: () {
                                widget.onLogInSelected();
                              },
                              child: Row(
                                children: [
                                  Text(
                                    switchToLoginButtonText,
                                    style: TextStyle(
                                      color: kPrimaryColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Icon(
                                    Icons.arrow_forward,
                                    color: kPrimaryColor,
                                  ),
                                ],
                              ),
                            ),
                          ],
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
    );
  }
}
