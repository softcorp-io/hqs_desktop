import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hqs_desktop/home/constants/text.dart';
import 'package:hqs_desktop/home/screens/departments/departments_page.dart';
import 'package:hqs_desktop/home/screens/admin_users/admin_users_page.dart';
import 'package:hqs_desktop/home/screens/profile/profile_page.dart';
import 'package:hqs_desktop/home/screens/settings/settings_page.dart';
import 'package:hqs_desktop/home/widgets/home_appbar.dart';
import 'package:hqs_desktop/service/hqs_user_service.dart';
import 'package:hqs_desktop/theme/theme.dart';
import 'package:koukicons/department.dart';
import 'package:koukicons/users2.dart';
import 'package:koukicons/blueprint.dart';
import 'package:koukicons/settings.dart';

class CustomNavigationrail extends StatefulWidget {
  final HqsService service;
  final Widget body;
  final HqsTheme theme;
  final showActive;
  final bool lightTheme;
  final Function changeTheme;

  CustomNavigationrail(
      {@required this.service,
      @required this.body,
      @required this.showActive,
      @required this.theme,
      @required this.lightTheme,
      @required this.changeTheme})
      : assert(service != null),
        assert(theme != null),
        assert(showActive != null),
        assert(lightTheme != null),
        assert(changeTheme != null),
        assert(body != null);

  @override
  _CustomNavigationrailState createState() => _CustomNavigationrailState(
      service: service, body: body, theme: theme, showActive: showActive, lightTheme: lightTheme, changeTheme: changeTheme);
}

/// This is the stateless widget that the main application instantiates.
class _CustomNavigationrailState extends State<CustomNavigationrail> {
  int _selectedIndex;
  Color activeColor;
  final HqsService service;
  final HqsTheme theme;
  final bool lightTheme;
  final Function changeTheme;
  bool showActive;
  Widget body;

  _CustomNavigationrailState(
      {@required this.service,
      @required this.body,
      @required this.showActive,
      @required this.theme,
      @required this.lightTheme,
      @required this.changeTheme})
      : assert(service != null),
        assert(theme != null),
        assert(showActive != null),
        assert(lightTheme != null),
        assert(changeTheme != null),
        assert(body != null) {
    _selectedIndex = 0;
    if (showActive) {
      this.activeColor = theme.primaryColor();
    } else {
      this.activeColor = theme.textColor();
    }
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
                    ? theme.primaryColor()
                    : theme.textColor()),
          ),
        ),
        () => DepartmentsPage(
              service: service,
              theme: theme,
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
                    ? theme.primaryColor()
                    : theme.textColor()),
          ),
        ),
        () => UsersPage(
              service: service,
              theme: theme,
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
                    ? theme.primaryColor()
                    : theme.textColor()),
          ),
        ),
        () => UsersPage(
              service: service,
              theme: theme,
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
                    ? theme.primaryColor()
                    : theme.textColor()),
          ),
        ),
        () => SettingsPage(
              service: service,
              lightTheme: lightTheme,
              changeTheme: changeTheme,
              theme: theme,
            ));
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
              theme: theme,
            );
          });
        },
        user: service.curUser,
        theme: theme,
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
                color: theme.defaultBackgroundColor(),
              ),
              Expanded(
                child: NavigationRail(
                  backgroundColor: theme.defaultBackgroundColor(),
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
              backgroundColor: theme.defaultBackgroundColor(),
            ),
            alignment: Alignment.topCenter,
          )),
        ],
      ),
    );
  }
}
