import 'package:flutter/material.dart';
import 'package:hqs_desktop/constants/constants.dart';

class HomeAppBar extends StatelessWidget with PreferredSizeWidget {
  @override
  final Size preferredSize;

  final String title;
  final bool shadow;

  HomeAppBar(
    this.title, this.shadow, {
    Key key,
  })  : assert(title != null),
        assert(shadow != null),
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
      elevation: shadow ? 4 : 0,
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
