import 'package:flutter/material.dart';
import 'package:dart_hqs/hqs_user_service.pb.dart';
import 'package:hqs_desktop/home/constants/text.dart';
import 'package:hqs_desktop/service/hqs_service.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeAppBar extends StatelessWidget with PreferredSizeWidget {
  @override
  final Size preferredSize;
  final bool shadow;
  final HqsService service;
  final User user;
  final Function navigateToProfile;
  final Function popContext;

  HomeAppBar(
      {this.shadow,
      this.service,
      @required this.user,
      @required this.popContext,
      @required this.navigateToProfile})
      : assert(shadow != null),
        assert(popContext != null),
        assert(navigateToProfile != null),
        assert(service != null),
        assert(user != null),
        preferredSize = Size.fromHeight(70.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(children: [
        Image(
          width: 50,
          height: 50,
          image: AssetImage('assets/images/logo-blue.png'),
        ),
        SizedBox(width: 10),
        Text(
          "Headquarters",
          style: GoogleFonts.poppins(
              fontSize: 19,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).textTheme.bodyText1.color),
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
              popContext();
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
                  ),
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
                      color: Theme.of(context).errorColor),
                ),
              ),
            ),
          ],
          child: Row(
            children: [
              Container(
                constraints: BoxConstraints(maxWidth: 140, minWidth: 20),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Text(
                    user.name,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Theme.of(context).textTheme.bodyText1.color,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              Icon(Icons.arrow_drop_down,
                  color: Theme.of(context).textTheme.bodyText1.color),
            ],
          ),
        ),
        SizedBox(width: 16)
      ],
      automaticallyImplyLeading: true,
      elevation: shadow ? 4 : 0,
      // add optional tabbar controller
    );
  }
}
