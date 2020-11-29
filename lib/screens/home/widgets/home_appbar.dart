import 'package:flutter/material.dart';
import 'package:hqs_desktop/constants/constants.dart';
import 'package:hqs_desktop/generated/hqs-user-service/proto/hqs-user-service.pb.dart';
import 'package:hqs_desktop/service/hqs_service.dart';

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
              return AppBar(
                title: Text(
                  title,
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.right,
                ),
                backgroundColor: kDarkBlue,
                automaticallyImplyLeading: true,
                iconTheme: new IconThemeData(color: Colors.white),
                elevation: shadow ? 4 : 0,
                // add optional tabbar controller
              );
            default:
              return AppBar(
                title: Text(
                  title,
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.right,
                ),
                backgroundColor: kDarkBlue,
                automaticallyImplyLeading: true,
                iconTheme: new IconThemeData(color: Colors.white),
                elevation: shadow ? 4 : 0,
                // add optional tabbar controller
              );
          }
        });
  }
}
