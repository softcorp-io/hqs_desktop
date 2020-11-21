import 'package:flutter/material.dart';
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Headquarters - by Softcorp',
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the Main widget.
        '/': (context) => ProfilePage(service: service,),
        '/profile': (context) => ProfilePage(
              service: service,
            ),
        '/departments': (context) => DepartmentsPage(service: service,),
      },
      // home: Main(),
    );
  }
}
