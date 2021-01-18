import 'package:flutter/material.dart';
import 'package:hqs_desktop/constants/constants.dart';
import 'package:dart_hqs/hqs_user_service.pb.dart';
import 'package:hqs_desktop/home/screens/organization/constants/text.dart';
import 'package:hqs_desktop/home/screens/organization/utils/admin_users_source.dart';
import 'package:hqs_desktop/home/screens/organization/utils/privilege_soruce.dart';
import 'package:hqs_desktop/home/screens/organization/widgets/create_user_dialog.dart';
import 'package:hqs_desktop/home/screens/organization/widgets/generate_signup_link.dart';
import 'package:hqs_desktop/home/screens/organization/widgets/new_privilege_dialog.dart';
import 'package:hqs_desktop/service/hqs_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dart_hqs/hqs_privilege_service.pbgrpc.dart' as privilegeService;

/// This is the stateless widget that the main application instantiates.
class OrganizationPage extends StatefulWidget {
  final HqsService service;
  final Function navigateToProfile;
  OrganizationPage({@required this.service, @required this.navigateToProfile})
      : assert(service != null),
        assert(navigateToProfile != null);

  @override
  _OrganizationPageState createState() => _OrganizationPageState(
      service: service, navigateToProfile: navigateToProfile);
}

class _OrganizationPageState extends State<OrganizationPage> {
  final HqsService service;
  final Function navigateToProfile;

  Future<void> setupResponse;

  List<User> users;
  List<privilegeService.Privilege> privileges;

  _OrganizationPageState(
      {@required this.service, @required this.navigateToProfile}) {
    setupResponse = setup();
  }

  Future<void> setup() async {
    await service.getAllUsers().then((response) {
      this.users = response.users;
      return response;
    });
    await service.getAllPrivileges().then((response) {
      this.privileges = response.privileges;
    });
  }

  void onUpdate() {
    service.getAllUsers().then((value) {
      setState(() {
        users = value.users;
      });
    });
    service.getAllPrivileges().then((value) {
      setState(() {
        privileges = value.privileges;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    AdminUsersSource usersSource;
    PrivilegeSource privilegeSource;
    Size size = MediaQuery.of(context).size;
    return FutureBuilder<void>(
      future: setupResponse,
      builder: (BuildContext futureContext, AsyncSnapshot<void> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            usersSource = AdminUsersSource(
              privileges: privileges,
              navigateToProfile: navigateToProfile,
              context: context,
              onUpdate: onUpdate,
              buildContext: context,
              service: service,
              onRowSelect: (index) {},
              usersData: users,
            );
            privilegeSource = PrivilegeSource(
              privileges: privileges,
              context: context,
              onUpdate: onUpdate,
              buildContext: context,
              service: service,
              onRowSelect: (index) {},
            );
            return Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      width: size.width * 0.8,
                      child: Container(
                        width: size.width,
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: PaginatedDataTable(
                            columnSpacing: 15,
                            actions: [
                              service.curPrivilege.managePrivileges
                                  ? SizedBox(
                                      width: 130,
                                      height: 45.0,
                                      child: RaisedButton(
                                        color: Theme.of(context).primaryColor,
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return StatefulBuilder(builder:
                                                    (context, setState) {
                                                  return NewPrivilegeDialog(
                                                      service: service,
                                                      onUpdate: onUpdate);
                                                });
                                              });
                                        },
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              cardBorderRadius),
                                        ),
                                        child: Text("New Privilege"),
                                      ),
                                    )
                                  : Container(),
                            ],
                            headingRowHeight: 80,
                            dataRowHeight: 80,
                            rowsPerPage: 5,
                            source: privilegeSource,
                            header: Text(
                              "Manage Privileges",
                              style: GoogleFonts.poppins(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            columns: _privilegeColGen(),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: size.width * 0.8,
                      child: Container(
                        width: size.width,
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: PaginatedDataTable(
                            columnSpacing: 15,
                            actions: [
                              service.curPrivilege.createUser
                                  ? SizedBox(
                                      height: 45.0,
                                      child: RaisedButton(
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return GenerateSignupTokenDialog(
                                                  service: service,
                                                );
                                              });
                                        },
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              cardBorderRadius),
                                        ),
                                        child:
                                            Text(adminUsersGenerateSignupLink),
                                      ),
                                    )
                                  : Container(),
                              service.curPrivilege.createUser
                                  ? SizedBox(
                                      width: 130,
                                      height: 45.0,
                                      child: RaisedButton(
                                        color: Theme.of(context).primaryColor,
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return StatefulBuilder(builder:
                                                    (context, setState) {
                                                  return CreateUserDialog(
                                                      service: service,
                                                      onUpdate: onUpdate);
                                                });
                                              });
                                        },
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              cardBorderRadius),
                                        ),
                                        child: Text(adminUsersCreateUserButton),
                                      ),
                                    )
                                  : Container(),
                            ],
                            headingRowHeight: 80,
                            dataRowHeight: 80,
                            rowsPerPage: 5,
                            source: usersSource,
                            header: Text(
                              adminUsersTableTitle,
                              style: GoogleFonts.poppins(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            columns: _usersColGen(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          default:
            return Padding(
                padding: EdgeInsets.only(top: 52),
                child: Align(
                    child: Container(
                      child: CircularProgressIndicator(),
                    ),
                    alignment: Alignment.center));
        }
        ;
      },
    );
  }

  List<DataColumn> _usersColGen() => <DataColumn>[
        DataColumn(
          label: Text(
            adminUsersProfileCol,
          ),
        ),
        DataColumn(
          label: Text(
            "Privilege",
          ),
        ),
        DataColumn(
          label: Align(
            alignment: Alignment.center,
            child: Text(
              adminUsersUpdatedAt,
            ),
          ),
        ),
        DataColumn(
          label: Text(
            adminUsersStatusCol,
          ),
        ),
        DataColumn(
          label: Text(
            "",
          ),
        ),
      ];

  List<DataColumn> _privilegeColGen() => <DataColumn>[
        DataColumn(
          label: Text(
            "Name",
          ),
        ),
        DataColumn(
          label: Text(
            "View Access",
          ),
        ),
        DataColumn(
          label: Align(
            alignment: Alignment.center,
            child: Text(
              "Create Access",
            ),
          ),
        ),
        DataColumn(
          label: Text(
            "Manage Privileges",
          ),
        ),
        DataColumn(
          label: Text(
            "Delete Access",
          ),
        ),
        DataColumn(
          label: Text(
            "Block Access",
          ),
        ),
        DataColumn(
          label: Text(
            "Reset Password Access",
          ),
        ),
        DataColumn(
          label: Text(""),
        ),
      ];
}
