import 'package:flutter/material.dart';
import 'package:hqs_desktop/home/widgets/custom_navigationrail.dart';
import 'package:hqs_desktop/service/hqs_user_service.dart';

class DepartmentsPage extends StatefulWidget {
  final HqsService service;

  DepartmentsPage({@required this.service}) : assert(service != null);

  @override
  _DepartmentsPageState createState() =>
      _DepartmentsPageState(service: service);
}

/// This is the stateless widget that the main application instantiates.
class _DepartmentsPageState extends State<DepartmentsPage> {
  final HqsService service;
  int _selectedIndex = 0;
  _DepartmentsPageState({@required this.service});

  @override
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('selectedIndex: $_selectedIndex'),
    );
  }
}
