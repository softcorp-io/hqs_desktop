import 'package:flutter/material.dart';
import 'package:hqs_desktop/constants/constants.dart';

class ProfileAppBar extends StatelessWidget with PreferredSizeWidget {
  @override
  final Size preferredSize;

  final String title;

  ProfileAppBar(
    this.title, {
    Key key,
  })  : assert(title != null),
        preferredSize = Size.fromHeight(50.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(color: Colors.white),
        textAlign: TextAlign.right,
      ),
      backgroundColor: kDarkColor,
      automaticallyImplyLeading: true,
      iconTheme: new IconThemeData(color: Colors.white),
      // add optional tabbar controller
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 16, left: 16),
          child: Icon(Icons.notifications),
        ),
        Padding(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Icon(Icons.messenger)),
        Padding(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Icon(Icons.person)),
      ],
    );
  }
}
