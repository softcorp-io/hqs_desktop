import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hqs_desktop/constants/constants.dart';
import 'package:hqs_desktop/home/constants/text.dart';
import 'package:hqs_desktop/home/screens/departments/departments_page.dart';
import 'package:hqs_desktop/home/screens/admin_users/admin_users_page.dart';
import 'package:hqs_desktop/home/widgets/home_appbar.dart';
import 'package:hqs_desktop/service/hqs_service.dart';

class CustomNavigationrail extends StatefulWidget {
  final HqsService service;
  final Widget body;
  final String title;

  CustomNavigationrail(
      {@required this.service, @required this.body, @required this.title})
      : assert(service != null),
        assert(body != null);

  @override
  _CustomNavigationrailState createState() =>
      _CustomNavigationrailState(service: service, body: body, title: title);
}

/// This is the stateless widget that the main application instantiates.
class _CustomNavigationrailState extends State<CustomNavigationrail> {
  int _selectedIndex;
  Color activeColor = Colors.blueAccent;
  final HqsService service;
  final title;
  Widget body;

  _CustomNavigationrailState(
      {@required this.service, @required this.body, @required this.title})
      : assert(service != null),
        assert(title != null),
        assert(body != null) {
    _selectedIndex = 0;
    if (this.title.toLowerCase() == appBarPopupProfileValue) {
      this.activeColor = Colors.grey[600];
    }
  }

  Map<NavigationRailDestination, Widget> buildNavigationRailDests() {
    Map<NavigationRailDestination, Widget> destinations =
        new Map<NavigationRailDestination, Widget>();
    destinations.putIfAbsent(
        NavigationRailDestination(
          icon: Icon(Icons.business, color: Colors.grey[800]),
          selectedIcon: Icon(Icons.business, color: activeColor),
          label: Text(
            departmentsNavRailLabel,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.grey[800],
            ),
          ),
        ),
        () => DepartmentsPage(service: service));
    destinations.putIfAbsent(
        NavigationRailDestination(
          icon: Icon(
            Icons.supervisor_account_rounded,
            color: Colors.grey[800],
          ),
          selectedIcon:
              Icon(Icons.supervisor_account_rounded, color: activeColor),
          label: Text(
            adminUsersNavRailLabel,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.grey[800],
            ),
          ),
        ),
        () => UsersPage(service: service));
    destinations.putIfAbsent(
        NavigationRailDestination(
          icon: Icon(
            Icons.architecture,
            color: Colors.grey[800],
          ),
          selectedIcon:
              Icon(Icons.architecture, color: activeColor),
          label: Text(
            projectsNavRailLabel,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.grey[800],
            ),
          ),
        ),
        () => UsersPage(service: service));
    return destinations;
  }

  @override
  Widget build(BuildContext context) {
    Map<NavigationRailDestination, Widget> destinations =
        buildNavigationRailDests();
    return Scaffold(
      appBar: HomeAppBar(
        service: widget.service,
        title: widget.title,
        shadow: true,
      ),
      body: Row(
        children: <Widget>[
          Column(
            children: [
              Container(
                height: 12,
                width: 200,
                color: Colors.white,
              ),
              Expanded(
                child: NavigationRail(
                  backgroundColor: kRailColor,
                  extended: true,
                  minExtendedWidth: 200,
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: (int index) {
                    setState(() {
                      var key = destinations.keys.toList()[index];
                      Widget result = destinations[key];
                      body = result;
                      activeColor = Colors.blueAccent[400];
                      _selectedIndex = index;
                    });
                  },
                  destinations: destinations.keys.toList(),
                ),
              ),
            ],
          ),
          VerticalDivider(thickness: 1, width: 1),
          // This is the main content.
          Expanded(
              child: Align(
            child: body,
            alignment: Alignment.topCenter,
          )),
        ],
      ),
    );
  }
}
