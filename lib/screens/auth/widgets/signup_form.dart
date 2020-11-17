import 'package:flutter/material.dart';
import 'package:hqs_desktop/constants/constants.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUp extends StatefulWidget {

  final Function onLogInSelected;

  SignUp({@required this.onLogInSelected});

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    
    return Padding(
      padding: EdgeInsets.all(size.height > 770 ? 64 : size.height > 670 ? 32 : 16),
      child: Center(
        child: Card(
          clipBehavior: Clip.antiAlias,
          elevation: 4,
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
                        "Sign up",
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
                    

                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Name',
                          labelText: 'Name',
                          suffixIcon: Icon(
                            Icons.person_outline,
                          ),
                        ),
                      ),

                      SizedBox(
                        height: 32,
                      ),

                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Email',
                          labelText: 'Email',
                          suffixIcon: Icon(
                            Icons.mail_outline,
                          ),
                        ),
                      ),

                      SizedBox(
                        height: 32,
                      ),

                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Password',
                          labelText: 'Password',
                          suffixIcon: Icon(
                            Icons.lock_outline,
                          ),
                        ),
                      ),

                      SizedBox(
                        height: 64,
                      ),

                      SizedBox(
                        height: 32,
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          Text(
                            "Already have an account?",
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
                                  "Log In",
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
    );
  }
}