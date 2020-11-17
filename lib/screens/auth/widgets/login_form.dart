import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hqs_desktop/constants/constants.dart';
import 'package:hqs_desktop/service/hqs_service.dart';

class LogIn extends StatefulWidget {
  final HqsService service;
  final Function onSignUpSelected;
  final Function onLogIn;

  LogIn({@required this.service, @required this.onSignUpSelected, @required this.onLogIn})
  : assert(HqsService != null),
    assert(onSignUpSelected != null),
    assert(onLogIn != null);

  @override
  _LogInState createState() => _LogInState(service: service, onLogIn: onLogIn);
}

class _LogInState extends State<LogIn> {
  final HqsService service;
  final Function onLogIn;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

   _LogInState({@required this.service, @required this.onLogIn});

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    final _formKey = GlobalKey<FormState>();

    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.all(size.height > 770 ? 64 : size.height > 670 ? 32 : 16),
          child: Center(
            child: Card(
              elevation: 4,
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(25),
                ),
              ),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 200),
                height: size.height * (size.height > 770 ? 0.7 : size.height > 670 ? 0.8 : 0.9),
                width: 600,
                color: Colors.white,
                child: Center(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(40),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          Text(
                            "Sign in",
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

          
                          Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                TextFormField(
                                  controller: _emailController,
                                  decoration: InputDecoration(
                                    hintText: 'Email',
                                    labelText: 'Email',
                                    suffixIcon: Icon(
                                    Icons.mail_outline,
                                    ),
                                  ),
                                  validator: (value) {
                                    var validEmail = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value);
                                    if (!validEmail){
                                      return "Please enter a valid email";
                                    }
                                    return null;
                                  },
                                ),
                                Padding(
                                  padding: EdgeInsets.all(10),
                                ),
                                TextFormField(
                                  obscureText: true,
                                  controller: _passwordController,
                                  decoration: InputDecoration(
                                    hintText: 'Password',
                                    labelText: 'Password',
                                    suffixIcon: Icon(
                                    Icons.lock_outline,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value.isEmpty){
                                      return "Please enter a valid password";
                                    }
                                    return null;
                                  },
                                ), 
                                Padding(
                                  padding: EdgeInsets.all(60),
                                ),
                                SizedBox(
                                    width: double.infinity,
                                    height: 50.0,
                                    child: RaisedButton(
                                        color: kPrimaryColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(18.0),
                                        ),
                                        textColor: Colors.white,
                                        onPressed: () async => {
                                          // Validate returns true if the form is valid, or false
                                          
                                          // otherwise.
                                          if (_formKey.currentState.validate()){
                                            service.authenticate(context, _emailController.text, _passwordController.text).then((token) => {
                                              if(token.token == "" ){
                                                _emailController.text = "",
                                                _passwordController.text = "",
                                              } else {
                                                // User is allowed to log in
                                                onLogIn(),
                                              }
                                            }),
                                          }
                                    },
                                    child: Text("Submit"),
                                  )
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(12),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "You do not have an account?",
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
                                  widget.onSignUpSelected();
                                },
                                child: Row(
                                  children: [

                                    Text(
                                      "Sign Up",
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
                          )
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