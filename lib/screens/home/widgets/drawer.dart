import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hqs_desktop/constants/constants.dart';
import 'package:hqs_desktop/generated/hqs-user-service/proto/hqs-user-service.pb.dart';
import 'package:hqs_desktop/screens/home/screens/departments/departments_page.dart';
import 'package:hqs_desktop/screens/home/screens/users/users_page.dart';
import 'package:hqs_desktop/service/hqs_service.dart';
import 'package:page_transition/page_transition.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeDrawer extends StatelessWidget {
  final HqsService service;
  Future<Response> userResponse;
  User user;

  HomeDrawer({@required this.service}) : assert(service != null) {
    user = service.curUser;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32.0),
        child: Drawer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 2.0,
                      offset: Offset(0.0, 3.0),
                    ),
                  ],
                  gradient: LinearGradient(
                      colors: [kBlueOne, kBlueTwoHalf],
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 18),
                    Center(
                      child: Image(
                        image: AssetImage("assets/images/logo-white.png"),
                        height: 120,
                        width: 120,
                      ),
                    ),
                    Text(
                      "Headquarters",
                      style: GoogleFonts.poppins(
                        fontSize: 26,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 18),
                  ],
                ),
              ),
              SizedBox(height: 26),

              // infrastructure
              Padding(
                padding: EdgeInsets.only(left: 8),
                child: Text(
                  "Infrastructure",
                  textAlign: TextAlign.right,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  'Projects',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[700],
                  ),
                ),
                onTap: () {},
              ),
              ListTile(
                title: Text(
                  'Departments',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey[700],
                  ),
                ),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    PageTransition(
                        type: PageTransitionType.fade,
                        child: DepartmentsPage(
                          service: service,
                        )),
                  );
                },
              ),
              SizedBox(height: 22),

              // admin
              user.allowView
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                          Padding(
                            padding: EdgeInsets.only(left: 8),
                            child: Text(
                              "Admin",
                              textAlign: TextAlign.right,
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[700],
                              ),
                            ),
                          ),
                          ListTile(
                            title: Text(
                              'Users',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey[700],
                              ),
                            ),
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                PageTransition(
                                    type: PageTransitionType.fade,
                                    child: UsersPage(
                                      service: service,
                                    )),
                              );
                            },
                          ),
                          ListTile(
                            title: Text(
                              'Departments',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey[700],
                              ),
                            ),
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                PageTransition(
                                    type: PageTransitionType.fade,
                                    child: DepartmentsPage(
                                      service: service,
                                    )),
                              );
                            },
                          ),
                        ])
                  : SizedBox(height: 0),
            ],
          ),
        ),
      ),
    );
  }
}
