import 'package:dart_hqs/hqs_user_service.pbgrpc.dart';
import 'package:flutter/material.dart';
import 'package:hqs_desktop/home/screens/profile/profile_page.dart';
import 'package:hqs_desktop/home/widgets/custom_navigationrail.dart';
import 'package:hqs_desktop/service/hqs_service.dart';

class HomePage extends StatefulWidget {
  final HqsService service;
  final Function changeTheme;
  HomePage({Key key, @required this.service, @required this.changeTheme})
      : assert(service != null),
        assert(changeTheme != null),
        super(key: key);

  @override
  HomePageState createState() {
    return HomePageState(
      service: service,
      changeTheme: changeTheme,
    );
  }
}

class HomePageState extends State<HomePage> {
  final HqsService service;
  final Function changeTheme;
  Future<Response> userResponse;
  HomePageState({Key key, @required this.service, @required this.changeTheme})
      : assert(service != null),
        assert(changeTheme != null) {
    userResponse = service.getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Response>(
        future: userResponse,
        builder: (BuildContext context, AsyncSnapshot<Response> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return CustomNavigationrail(
                changeTheme: changeTheme,
                service: service,
                showActive: false,
                body: ProfilePage(
                  service: service,
                  onUpdate: () {
                    setState(() {});
                  },
                ),
              );

            default:
              return Align(
                  child: Container(
                    child: CircularProgressIndicator(),
                  ),
                  alignment: Alignment.center);
          }
        });
  }
}
