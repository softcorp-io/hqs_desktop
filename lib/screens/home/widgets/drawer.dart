import 'package:flutter/material.dart';
import 'package:hqs_desktop/screens/home/screens/departments/departments_page.dart';
import 'package:hqs_desktop/screens/home/screens/profile/profile_page.dart';
import 'package:hqs_desktop/service/hqs_service.dart';
import 'package:page_transition/page_transition.dart';

class HomeDrawer extends StatelessWidget {
  final HqsService service;

  HomeDrawer({@required this.service}) : assert(service != null);

  @override
  Widget build(BuildContext context) {
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
                  "Pratap Kumar",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                accountEmail: new Text(
                  "kprathap23@gmail.com",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: AssetImage(
                      "https://randomuser.me/api/portraits/men/46.jpg"),
                ),
              ),
              ListTile(
                title: Text('Profile'),
                onTap: () {
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
            ],
          ),
        ),
      ),
    );
  }
}
