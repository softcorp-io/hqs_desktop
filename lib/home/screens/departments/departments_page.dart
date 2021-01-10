import 'package:flutter/material.dart';
import 'package:hqs_desktop/home/widgets/custom_navigationrail.dart';
import 'package:hqs_desktop/service/hqs_user_service.dart';
import 'package:hqs_desktop/theme/theme.dart';

class DepartmentsPage extends StatefulWidget {
  final HqsService service;
  final HqsTheme theme;
  DepartmentsPage({@required this.service, @required this.theme})
      : assert(theme != null),
        assert(service != null);

  @override
  _DepartmentsPageState createState() =>
      _DepartmentsPageState(service: service, theme: theme);
}

/// This is the stateless widget that the main application instantiates.
class _DepartmentsPageState extends State<DepartmentsPage> {
  final HqsService service;
  final HqsTheme theme;
  int _selectedIndex = 0;
  _DepartmentsPageState({@required this.service, @required this.theme});

  @override
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('selectedIndex: $_selectedIndex'),
    );
  }
}