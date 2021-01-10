import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hqs_desktop/home/constants/text.dart';
import 'package:hqs_desktop/home/screens/departments/departments_page.dart';
import 'package:hqs_desktop/home/screens/admin_users/admin_users_page.dart';
import 'package:hqs_desktop/home/screens/profile/profile_page.dart';
import 'package:hqs_desktop/home/screens/settings/settings_page.dart';
import 'package:hqs_desktop/home/widgets/home_appbar.dart';
import 'package:hqs_desktop/service/hqs_user_service.dart';
import 'package:koukicons/department.dart';
import 'package:koukicons/users2.dart';
import 'package:koukicons/blueprint.dart';
import 'package:koukicons/settings.dart';

class CustomNavigationrail extends StatefulWidget {
  final HqsService service;
  final Widget body;
  final showActive;
  final Function changeTheme;

  CustomNavigationrail(
      {@required this.service,
      @required this.body,
      @required this.showActive,
      @required this.changeTheme})
      : assert(service != null),
        assert(showActive != null),
        assert(changeTheme != null),
        assert(body != null);

  @override
  _CustomNavigationrailState createState() => _CustomNavigationrailState(
      service: service,
      body: body,
      showActive: showActive,
      changeTheme: changeTheme);
}

/// This is the stateless widget that the main application instantiates.
class _CustomNavigationrailState extends State<CustomNavigationrail> {
  int _selectedIndex;
  final HqsService service;
  final Function changeTheme;
  bool showActive;
  Widget body;

  _CustomNavigationrailState(
      {@required this.service,
      @required this.body,
      @required this.showActive,
      @required this.changeTheme})
      : assert(service != null),
        assert(showActive != null),
        assert(changeTheme != null),
        assert(body != null) {
    _selectedIndex = 0;
  }

  Map<NavigationRailDestination, Widget> buildNavigationRailDests() {
    Map<NavigationRailDestination, Widget> destinations =
        new Map<NavigationRailDestination, Widget>();
    destinations.putIfAbsent(
        NavigationRailDestination(
          icon: KoukiconsDepartment(
            height: 26,
          ),
          selectedIcon: KoukiconsDepartment(
            height: 26,
          ),
          label: Text(
            departmentsNavRailLabel,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: (_selectedIndex == 0 && showActive)
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).textTheme.overline.color,
            ),
          ),
        ),
        () => DepartmentsPage(
              service: service,
            ));
    destinations.putIfAbsent(
        NavigationRailDestination(
          icon: KoukiconsUsers2(
            height: 26,
          ),
          selectedIcon: KoukiconsUsers2(
            height: 26,
          ),
          label: Text(
            adminUsersNavRailLabel,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: (_selectedIndex == 1 && showActive)
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).textTheme.overline.color,
            ),
          ),
        ),
        () => UsersPage(
              service: service,
            ));
    destinations.putIfAbsent(
        NavigationRailDestination(
          icon: KoukiconsBlueprint(
            height: 26,
          ),
          selectedIcon: KoukiconsBlueprint(
            height: 26,
          ),
          label: Text(
            projectsNavRailLabel,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: (_selectedIndex == 2 && showActive)
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).textTheme.overline.color,
            ),
          ),
        ),
        () => UsersPage(
              service: service,
            ));
    destinations.putIfAbsent(
        NavigationRailDestination(
          icon: KoukiconsSettings(
            height: 26,
          ),
          selectedIcon: KoukiconsSettings(
            height: 26,
          ),
          label: Text(
            SettingsNavRailLabel,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: (_selectedIndex == 3 && showActive)
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).textTheme.overline.color,
            ),
          ),
        ),
        () => SettingsPage(changeTheme: changeTheme,));
    return destinations;
  }

  @override
  Widget build(BuildContext context) {
    Map<NavigationRailDestination, Widget> destinations =
        buildNavigationRailDests();
    return Scaffold(
      appBar: HomeAppBar(
        navigateToProfile: () {
          setState(() {
            showActive = false;
            body = ProfilePage(
              service: service,
            );
          });
        },
        user: service.curUser,
        service: widget.service,
        shadow: true,
      ),
      body: Row(
        children: <Widget>[
          Column(
            children: [
              Container(
                height: 12,
                width: 200,
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
              Expanded(
                child: NavigationRail(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  extended: true,
                  minExtendedWidth: 200,
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: (int index) {
                    var key = destinations.keys.toList()[index];
                    Widget result = destinations[key];
                    setState(() {
                      showActive = true;
                      _selectedIndex = index;
                      body = result;
                    });
                  },
                  destinations: destinations.keys.toList(),
                ),
              ),
            ],
          ),
          // This is the main content.
          Expanded(
              child: Align(
            child: Scaffold(
              body: body,
            ),
            alignment: Alignment.topCenter,
          )),
        ],
      ),
    );
  }
}
