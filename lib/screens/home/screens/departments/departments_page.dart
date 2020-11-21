import 'package:flutter/material.dart';
import 'package:hqs_desktop/screens/home/widgets/home_appbar.dart';
import 'package:hqs_desktop/screens/home/widgets/drawer.dart';
import 'package:hqs_desktop/service/hqs_service.dart';

class DepartmentsPage extends StatelessWidget {
  final HqsService service;
  DepartmentsPage({@required this.service});

  @override
  Widget build(BuildContext context) {
    return Main(service: service,);
  }
}

/// This is the stateless widget that the main application instantiates.
class Main extends StatelessWidget {
  final HqsService service;
  Main({@required this.service});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: HomeDrawer(
        service: service,
      ),
      appBar: HomeAppBar("Profile", true),
      body: Center(child: Text('See your messages here!')),
    );
  }
}
