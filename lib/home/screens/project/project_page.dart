import 'package:flutter/material.dart';
import 'package:hqs_desktop/service/hqs_service.dart';

class ProjectPage extends StatefulWidget {
  final HqsService service;
  ProjectPage({
    @required this.service,
  }) : assert(service != null);

  @override
  _ProjectPageState createState() =>
      _ProjectPageState(service: service);
}

/// This is the stateless widget that the main application instantiates.
class _ProjectPageState extends State<ProjectPage> {
  final HqsService service;
  int _selectedIndex = 0;
  _ProjectPageState({@required this.service});

  @override
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('selectedIndex: $_selectedIndex'),
    );
  }
}
