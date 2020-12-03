import 'package:flutter/material.dart';
import 'package:hqs_desktop/constants/constants.dart';
import 'package:hqs_desktop/generated/hqs-user-service/proto/hqs-user-service.pb.dart';
import 'package:hqs_desktop/service/hqs_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:hqs_desktop/screens/home/screens/profile/profile_page.dart';

class HomeAppBar extends StatelessWidget with PreferredSizeWidget {
  @override
  final Size preferredSize;

  final String title;
  final bool shadow;
  final HqsService service;
  Future<Response> userResponse;
  User user;

  HomeAppBar({this.title, this.shadow, this.service})
      : assert(title != null),
        assert(shadow != null),
        assert(service != null),
        preferredSize = Size.fromHeight(70.0) {
    this.user = service.curUser;
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(color: Colors.white),
        textAlign: TextAlign.right,
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 8, top: 4),
          child: CircleAvatar(
            backgroundImage: NetworkImage(user.image),
            backgroundColor: Colors.grey[800],
            radius: 24,
          ),
        ),
        PopupMenuButton<String>(
          offset: const Offset(0, 330),
          onSelected: (String result) {
            if (result.toLowerCase() == "profile") {
              service.getCurrentUser().then((response) {
                Navigator.pushReplacement(
                    context,
                    PageTransition(
                        type: PageTransitionType.fade,
                        child: ProfilePage(
                          service: service,
                        )));
              });
            } else if (result.toLowerCase() == "logout") {
              service.logout();
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            PopupMenuItem<String>(
              value: "profile",
              child: Container(
                width: 150,
                child: Text(
                  'Profile',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            PopupMenuItem<String>(
              value: "logout",
              child: Container(
                child: Text(
                  'Logout',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
          ],
          child: Row(
            children: [
              Text(
                user.name,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              Icon(
                Icons.arrow_drop_down,
                color: Colors.white,
              )
            ],
          ),
        ),
        SizedBox(width: 16)
      ],
      backgroundColor: Colors.grey[900],
      automaticallyImplyLeading: true,
      iconTheme: new IconThemeData(color: Colors.white),
      elevation: shadow ? 4 : 0,
      // add optional tabbar controller
    );
  }
}
