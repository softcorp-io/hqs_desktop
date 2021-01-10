import 'package:dart_hqs/hqs_user_service.pbgrpc.dart';
import 'package:flutter/material.dart';
import 'package:hqs_desktop/home/screens/profile/profile_page.dart';
import 'package:hqs_desktop/home/widgets/custom_navigationrail.dart';
import 'package:hqs_desktop/service/hqs_user_service.dart';
import 'package:hqs_desktop/theme/theme.dart';

class HomePage extends StatefulWidget {
  final HqsService service;
  final HqsTheme theme;
  final bool lightTheme;
  final Function changeTheme;
  HomePage(
      {Key key,
      @required this.service,
      @required this.theme,
      @required this.lightTheme,
      @required this.changeTheme})
      : assert(service != null),
        assert(theme != null),
        assert(lightTheme != null),
        assert(changeTheme != null),
        super(key: key);

  @override
  HomePageState createState() {
    return HomePageState(
      service: service,
      theme: theme,
      lightTheme: lightTheme,
      changeTheme: changeTheme,
    );
  }
}

class HomePageState extends State<HomePage> {
  final HqsService service;
  final HqsTheme theme;
  final bool lightTheme;
  final Function changeTheme;
  Future<Response> userResponse;
  HomePageState(
      {Key key,
      @required this.service,
      @required this.theme,
      @required this.lightTheme,
      @required this.changeTheme})
      : assert(service != null),
        assert(lightTheme != null),
        assert(changeTheme != null),
        assert(theme != null) {
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
                lightTheme: lightTheme,
                service: service,
                showActive: false,
                theme: theme,
                body: ProfilePage(service: service, theme: theme),
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
