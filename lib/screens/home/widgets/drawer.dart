import 'package:flutter/material.dart';
import 'package:hqs_desktop/generated/hqs-user-service/proto/hqs-user-service.pb.dart';
import 'package:hqs_desktop/screens/home/screens/departments/departments_page.dart';
import 'package:hqs_desktop/screens/home/screens/profile/profile_page.dart';
import 'package:hqs_desktop/service/hqs_service.dart';
import 'package:page_transition/page_transition.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeDrawer extends StatelessWidget {
  final HqsService service;
  Future<Response> userResponse;
  User user;

  HomeDrawer({@required this.service}) : assert(service != null) {
    this.userResponse = service.getCurrentUser().then((value) {
      if (value.user.id != "") {
        this.user = value.user;
      }
      return value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Response>(
        future: userResponse,
        builder: (BuildContext context, AsyncSnapshot<Response> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return Padding(
                padding: EdgeInsets.all(8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18.0),
                  child: Drawer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          child: Column(
                            children: [
                              SizedBox(height: 18),
                              Container(
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
                                    radius: 50,
                                    backgroundImage: NetworkImage(user.image),
                                    backgroundColor: Colors.amber[100],
                                  )),
                              SizedBox(height: 12),
                              Text(
                                user.name,
                                style: GoogleFonts.poppins(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[900],
                                ),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    user.email,
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: IconButton(
                                      icon: Icon(Icons.settings),
                                      onPressed: () {
                                        Navigator.pushReplacement(
                                          context,
                                          PageTransition(
                                              type: PageTransitionType.fade,
                                              child: ProfilePage(
                                                service: service,
                                              )),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 52),

                        // infrastructure
                        Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: Text(
                            "Infrastructure",
                            textAlign: TextAlign.right,
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                        ListTile(
                          title: Text('Projects'),
                          onTap: () {},
                        ),
                        ListTile(
                          title: Text('Departments'),
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
                        Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: Text(
                            "Admin",
                            textAlign: TextAlign.right,
                            style: GoogleFonts.poppins(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                        ListTile(
                          title: Text('Users'),
                          onTap: () {},
                        ),
                        ListTile(
                          title: Text('Departments'),
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
                        // logout
                        Expanded(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: ListTile(
                              title: Text(
                                'Logout',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.red[800],
                                ),
                              ),
                              onTap: () {
                                service.logout();
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            default:
              return Padding(
                padding: EdgeInsets.all(8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18.0),
                  child: Drawer(
                    // Add a ListView to the drawer. This ensures the user can scroll
                    // through the options in the drawer if there isn't enough vertical
                    // space to fit everything.
                    child: ListView(
                      // Important: Remove any padding from the ListView.
                      padding: EdgeInsets.zero,
                      children: <Widget>[
                        new UserAccountsDrawerHeader(
                          accountName: new Text(
                            "",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          accountEmail: new Text(
                            "",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                          ),
                          currentAccountPicture: CircleAvatar(),
                        ),
                      ],
                    ),
                  ),
                ),
              );
          }
        });
  }
}
