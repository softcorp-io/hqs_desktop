import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hqs_desktop/home/constants/text.dart';
import 'package:hqs_desktop/home/screens/departments/departments_page.dart';
import 'package:hqs_desktop/home/screens/organization/organization_page.dart';
import 'package:hqs_desktop/home/screens/profile/profile_page.dart';
import 'package:hqs_desktop/home/screens/settings/settings_page.dart';
import 'package:hqs_desktop/home/widgets/home_appbar.dart';
import 'package:hqs_desktop/service/hqs_service.dart';
import 'package:koukicons/addApp.dart';
import 'package:koukicons/blueprint.dart';
import 'package:koukicons/calendar.dart';
import 'package:koukicons/circuit.dart';
import 'package:koukicons/collaboration.dart';
import 'package:koukicons/department.dart';
import 'package:koukicons/news.dart';
import 'package:koukicons/newspaper.dart';
import 'package:koukicons/organization.dart';
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

  Text getText(String text) {
    return Text(
      text,
      style: showActive
          ? GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w500,
            )
          : GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Theme.of(context)
                  .navigationRailTheme
                  .unselectedLabelTextStyle
                  .color),
    );
  }

  Map<NavigationRailDestination, Widget> buildNavigationRailDests() {
    Map<NavigationRailDestination, Widget> destinations =
        new Map<NavigationRailDestination, Widget>();
    destinations.putIfAbsent(
      NavigationRailDestination(
        icon: KoukiconsNewspaper(
          height: 26,
        ),
        selectedIcon: KoukiconsNewspaper(
          height: 26,
        ),
        label: getText("News"),
      ),
      () => SettingsPage(
        changeTheme: changeTheme,
      ),
    );
    destinations.putIfAbsent(
      NavigationRailDestination(
        icon: KoukiconsBlueprint(
          height: 26,
        ),
        selectedIcon: KoukiconsBlueprint(
          height: 26,
        ),
        label: getText("Projects"),
      ),
      () => SettingsPage(
        changeTheme: changeTheme,
      ),
    );
    destinations.putIfAbsent(
      NavigationRailDestination(
        icon: KoukiconsDepartment(
          height: 26,
        ),
        selectedIcon: KoukiconsDepartment(
          height: 26,
        ),
        label: getText(departmentsNavRailLabel),
      ),
      () => DepartmentsPage(
        service: service,
      ),
    );
    destinations.putIfAbsent(
      NavigationRailDestination(
        icon: KoukiconsCalendar(
          height: 26,
        ),
        selectedIcon: KoukiconsCalendar(
          height: 26,
        ),
        label: getText("Calendar"),
      ),
      () => SettingsPage(
        changeTheme: changeTheme,
      ),
    );
    destinations.putIfAbsent(
      NavigationRailDestination(
        icon: KoukiconsCollaboration(
          height: 26,
        ),
        selectedIcon: KoukiconsCollaboration(
          height: 26,
        ),
        label: getText("Groups"),
      ),
      () => SettingsPage(
        changeTheme: changeTheme,
      ),
    );
    destinations.putIfAbsent(
      NavigationRailDestination(
        icon: KoukiconsAddApp(
          height: 26,
        ),
        selectedIcon: KoukiconsAddApp(
          height: 26,
        ),
        label: getText("App Store"),
      ),
      () => SettingsPage(
        changeTheme: changeTheme,
      ),
    );
    if (service.curPrivilege.viewAllUsers) {
      destinations.putIfAbsent(
        NavigationRailDestination(
          icon: KoukiconsOrganization(
            height: 26,
          ),
          selectedIcon: KoukiconsOrganization(
            height: 26,
          ),
          label: getText(organizationNavRailLabel),
        ),
        () => OrganizationPage(
          navigateToProfile: () {
            setState(() {
              showActive = false;
              body = ProfilePage(
                onUpdate: () {
                  setState(() {});
                },
                service: service,
              );
            });
          },
          service: service,
        ),
      );
    }
    destinations.putIfAbsent(
      NavigationRailDestination(
        icon: KoukiconsSettings(
          height: 26,
        ),
        selectedIcon: KoukiconsSettings(
          height: 26,
        ),
        label: getText(SettingsNavRailLabel),
      ),
      () => SettingsPage(
        changeTheme: changeTheme,
      ),
    );
    return destinations;
  }

  @override
  Widget build(BuildContext context) {
    Map<NavigationRailDestination, Widget> destinations =
        buildNavigationRailDests();
    return Scaffold(
      appBar: HomeAppBar(
        popContext: () {},
        navigateToProfile: () {
          setState(() {
            showActive = false;
            body = ProfilePage(
              onUpdate: () {
                setState(() {});
              },
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
