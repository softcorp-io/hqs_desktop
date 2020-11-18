import 'package:flutter/material.dart';
import 'package:hqs_desktop/screens/home/widgets/drawer.dart';
import 'package:hqs_desktop/screens/home/screens/profile/profile_page.dart';
import 'package:hqs_desktop/service/hqs_service.dart';
import 'package:hqs_desktop/screens/home/widgets/appbar.dart';

class HomePage extends StatefulWidget {
  final HqsService service;
  
  HomePage({Key key, @required this.service}) 
  : assert(service != null),
    super(key: key)
  ;

  @override
  _HomePageState createState() => _HomePageState(service: service);
}

class _HomePageState extends State<HomePage> {
  final HqsService service;
  _HomePageState({Key key, @required this.service}) 
  : assert(service != null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: HomeDrawer(),
      appBar: CustomAppBar("Home"),
      body: ProfilePage(service: service),
    );
  }
}
