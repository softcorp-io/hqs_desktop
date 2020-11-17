import 'package:flutter/material.dart';
import 'package:hqs_desktop/constants/constants.dart';
import 'package:hqs_desktop/generated/hqs-user-service/proto/hqs-user-service.pb.dart';
import 'package:hqs_desktop/service/hqs_service.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileCard extends StatefulWidget {
  final HqsService service;
  final User user;
  final double profileImageRadius;
  ProfileCard({@required this.service, @required this.user, @required this.profileImageRadius})
      : assert(service != null),
        assert(profileImageRadius != null);

  @override
  _ProfileCardState createState() =>
      _ProfileCardState(service: service, user: user, profileImageRadius:profileImageRadius);
}

class _ProfileCardState extends State<ProfileCard> {
  final HqsService service;
  final User user;
  final double profileImageRadius;
  _ProfileCardState({@required this.service, @required this.user, @required this.profileImageRadius})
      : assert(service != null),
        assert(user != null),
        assert(profileImageRadius != null);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(
            top: profileImageRadius / 2.0,
          ),

          ///here we create space for the circle avatar to get ut of the box
          child: Card(
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(25),
              ),
            ),
            //height: 350.0,
            elevation: 4,
            //width: double.infinity,
            child: Padding(
                padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: profileImageRadius / 2,
                    ),
                    Text(
                      user.name,
                      style: GoogleFonts.poppins(
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(18),
                      child: Text(
                        user.description.isEmpty
                            ? "No decription added yet."
                            : user.description,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Text(
                                'Email',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black87,
                                ),
                              ),
                              SelectableText(
                                user.email,
                                style: TextStyle(
                                    fontSize: 18.0,
                                    color: kPrimaryColor,
                                    fontFamily: ''),
                              ),
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              Text(
                                'Phone',
                                style: TextStyle(
                                    fontSize: 16.0, color: Colors.black87),
                              ),
                              SelectableText(
                                user.phone.isEmpty
                                    ? "No number specified"
                                    : user.dialCode + " " + user.phone,
                                style: TextStyle(
                                    fontSize: 18.0,
                                    color: kPrimaryColor,
                                    fontFamily: ''),
                              ),
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              Text(
                                'Gender',
                                style: TextStyle(
                                    fontSize: 16.0, color: Colors.black87),
                              ),
                              SelectableText(
                                user.gender == false ? "Male" : "Female",
                                style: TextStyle(
                                    fontSize: 18.0,
                                    color: kPrimaryColor,
                                    fontFamily: ''),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 80.0,
                    ),
                  ],
                )),
          ),
        ),

        ///Image Avatar
        Container(
            width: profileImageRadius,
            height: profileImageRadius,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8.0,
                  offset: Offset(0.0, 5.0),
                ),
              ],
            ),
            child: CircleAvatar(
              backgroundImage: NetworkImage(user.image),
              backgroundColor: Colors.white,
            )),
      ],
    );
  }
}
