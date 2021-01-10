import 'package:flutter/material.dart';
import 'package:dart_hqs/hqs_user_service.pb.dart';
import 'package:hqs_desktop/home/constants/text.dart';
import 'package:hqs_desktop/service/hqs_user_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hqs_desktop/theme/theme.dart';

class HomeAppBar extends StatelessWidget with PreferredSizeWidget {
  @override
  final Size preferredSize;
  final HqsTheme theme;
  final bool shadow;
  final HqsService service;
  final User user;
  final Function navigateToProfile;

  HomeAppBar(
      {this.shadow,
      this.service,
      @required this.theme,
      @required this.user,
      @required this.navigateToProfile})
      : assert(theme != null),
        assert(shadow != null),
        assert(navigateToProfile != null),
        assert(service != null),
        assert(user != null),
        preferredSize = Size.fromHeight(70.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      brightness: Brightness.light,
      title: Row(children: [
        Image(
          width: 50,
          height: 50,
          image: AssetImage('assets/images/logo-blue.png'),
        ),
        SizedBox(width: 10),
        Text(
          appBarPlatformTitle,
          style: GoogleFonts.poppins(
            color: theme.titleColor(),
            fontSize: 19,
            fontWeight: FontWeight.w500,
          ),
        )
      ]),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 8, top: 4),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black38,
                  blurRadius: 0.5,
                  offset: Offset(0.0, 0.5),
                ),
              ],
            ),
            child: CircleAvatar(
              backgroundImage: NetworkImage(user.image),
              backgroundColor: Colors.transparent,
              radius: 24,
            ),
          ),
        ),
        PopupMenuButton<String>(
          offset: const Offset(0, 50),
          onSelected: (String result) {
            if (result.toLowerCase() == appBarPopupProfileValue) {
              service.getCurrentUser().then((response) {
                navigateToProfile();
              });
            } else if (result.toLowerCase() == appBarPopupLogoutValue) {
              service.logout();
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            PopupMenuItem<String>(
              value: appBarPopupProfileValue,
              child: Container(
                width: 150,
                child: Text(
                  appBarPopupProfileTitle,
                  style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: theme.titleColor()),
                ),
              ),
            ),
            PopupMenuItem<String>(
              value: appBarPopupLogoutValue,
              child: Container(
                child: Text(
                  appBarPopupLogoutTitle,
                  style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: theme.dangerColor()),
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
                    fontWeight: FontWeight.w400,
                    color: theme.titleColor()),
              ),
              Icon(Icons.arrow_drop_down, color: theme.titleColor())
            ],
          ),
        ),
        SizedBox(width: 16)
      ],
      backgroundColor: theme.appbarColor(),
      automaticallyImplyLeading: false,
      elevation: shadow ? 4 : 0,
      // add optional tabbar controller
    );
  }
}
