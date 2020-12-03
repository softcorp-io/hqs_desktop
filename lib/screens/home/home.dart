import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:hqs_desktop/generated/hqs-user-service/proto/hqs-user-service.pb.dart';
import 'package:hqs_desktop/screens/home/widgets/drawer.dart';
import 'package:hqs_desktop/screens/home/screens/profile/profile_page.dart';
import 'package:hqs_desktop/service/hqs_service.dart';
import 'package:hqs_desktop/screens/home/widgets/home_appbar.dart';
import 'package:hqs_desktop/screens/home/screens/departments/departments_page.dart';

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
                title: 'Headquarters - by Softcorp',
                initialRoute: '/',
                routes: {
                  // When navigating to the "/" route, build the Main widget.
                  '/': (context) => ProfilePage(
                        service: service,
                      ),
                  '/profile': (context) => ProfilePage(
                        service: service,
                      ),
                  '/departments': (context) => DepartmentsPage(
                        service: service,
                      ),
                },
                // home: Main(),
              );
            default:
              return Scaffold(
                backgroundColor: Colors.grey[100],
                body: MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: 'Headquarters - by Softcorp',
                  initialRoute: '/',
                  routes: {
                    // When navigating to the "/" route, build the Main widget.
                    '/': (context) => Padding(
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
