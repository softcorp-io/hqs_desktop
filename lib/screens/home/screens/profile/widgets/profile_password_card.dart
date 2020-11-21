import 'package:flutter/material.dart';
import 'package:hqs_desktop/constants/constants.dart';
import 'package:hqs_desktop/service/hqs_service.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilePasswordCard extends StatefulWidget {
  final HqsService service;
  final Function onUpdate;
  final double profileImageRadius;

  ProfilePasswordCard(
      {@required this.service,
      @required this.onUpdate,
      @required this.profileImageRadius})
      : assert(service != null),
        assert(profileImageRadius != null);

  @override
  _ProfilePasswordCardState createState() => _ProfilePasswordCardState(
      service: service,
      onUpdate: onUpdate,
      profileImageRadius: profileImageRadius);
}

class _ProfilePasswordCardState extends State<ProfilePasswordCard> {
  // form controllers
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();

  // constructor parameters
  final HqsService service;
  final Function onUpdate;
  final double profileImageRadius;

  _ProfilePasswordCardState(
      {@required this.service,
      @required this.onUpdate,
      @required this.profileImageRadius}) {
    assert(service != null);
    assert(profileImageRadius != null);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 120 / 2),
          child: Card(
            elevation: 4,
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(25),
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
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Flexible(
                          child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: TextFormField(
                              controller: _oldPasswordController,
                              decoration: new InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: kPrimaryColor, width: 1.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.grey[300], width: 1.0),
                                ),
                                hintText: 'Old Password',
                                labelText: 'Old Password',
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Please specify a valid password";
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(height: 12),
                          TextFormField(
                            controller: _newPasswordController,
                            decoration: new InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: kPrimaryColor, width: 1.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.grey[300], width: 1.0),
                              ),
                              hintText: 'New Password',
                              labelText: 'New Password',
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Please specify a valid password";
                              }
                              return null;
                            },
                          ),
                        ],
                      )),
                      Container(
                          width: size.width / 2,
                          height: 200,
                          child: Card(
                              elevation: 0,
                              clipBehavior: Clip.antiAlias,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(13),
                                ),
                              ),
                              color: Colors.grey[100],
                              child: Padding(
                                padding: EdgeInsets.all(16),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Password Rules",
                                        style: GoogleFonts.poppins(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(height: 12),
                                      Text(
                                        " 1. Needs to be at least 6 characters long.",
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(height: 12),
                                      Text(
                                        " 2. Needs to contain at least one uppercase letter.",
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(height: 12),
                                      Text(
                                        " 3. Needs to contain at least one number.",
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ]),
                              ))),
                    ],
                  ),
                ),
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
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          textColor: Colors.white,
                          onPressed: () async =>
                              {if (_formKey.currentState.validate()) {}},
                          child: Text("Update Profile"),
                        ))),
              ]),
            ),
          ),
        ),
      ],
    );
  }
}
