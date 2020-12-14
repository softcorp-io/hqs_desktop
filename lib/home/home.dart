import 'package:flutter/material.dart';
import 'package:hqs_desktop/generated/hqs-user-service/proto/hqs-user-service.pb.dart';
import 'package:hqs_desktop/home/constants/text.dart';
import 'package:hqs_desktop/home/screens/profile/profile_page.dart';
import 'package:hqs_desktop/service/hqs_service.dart';
import 'package:hqs_desktop/home/screens/departments/departments_page.dart';

class HomePage extends StatelessWidget {
  final HqsService service;

  HomePage({Key key, @required this.service})
      : assert(service != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Response>(
        future: service.getCurrentUser(),
        builder: (BuildContext context, AsyncSnapshot<Response> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: platformTitle,
                initialRoute: baseRoute,
                routes: {
                  // When navigating to the "/" route, build the Main widget.
                  baseRoute: (context) => ProfilePage(
                        service: service,
                      ),
                  profileRoute: (context) => ProfilePage(
                        service: service,
                      ),
                  departmentsRoute: (context) => DepartmentsPage(
                        service: service,
                      ),
                },
                // home: Main(),
              );
            default:
              return Scaffold(
                body: MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: platformTitle,
                  initialRoute: baseRoute,
                  routes: {
                    // When navigating to the "/" route, build the Main widget.
                    baseRoute: (context) => Padding(
                        padding: EdgeInsets.only(top: 120),
                        child: Align(
                            child: Container(
                              child: CircularProgressIndicator(),
                            ),
                            alignment: Alignment.center)),
                  },
                ),
              );
          }
        });
  }
}
