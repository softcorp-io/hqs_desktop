import 'package:flutter/material.dart';
import 'package:hqs_desktop/constants/constants.dart';
import 'package:hqs_desktop/generated/hqs-user-service/proto/hqs-user-service.pb.dart';
import 'package:hqs_desktop/home/screens/admin_users/constants/text.dart';
import 'package:hqs_desktop/home/screens/admin_users/utils/users_source.dart';
import 'package:hqs_desktop/home/screens/admin_users/widgets/create_user_dialog.dart';
import 'package:hqs_desktop/home/screens/admin_users/widgets/generate_signup_token_dialog.dart';
import 'package:hqs_desktop/service/hqs_service.dart';
import 'package:google_fonts/google_fonts.dart';

/// This is the stateless widget that the main application instantiates.
class UsersPage extends StatefulWidget {
  final HqsService service;

  UsersPage({@required this.service}) : assert(service != null);

  @override
  _UsersPageState createState() => _UsersPageState(service: service);
}

class _UsersPageState extends State<UsersPage> {
  final HqsService service;
  Future<Response> usersResponse;
  List<User> users;
  _UsersPageState({@required this.service}) {
    usersResponse = service.getAllUsers().then((response) {
      this.users = response.users;
      return response;
    });
  }

  void onUpdate() {
    service.getAllUsers().then((value) {
      setState(() {
        users = value.users;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    UsersSource usersSource;
    Size size = MediaQuery.of(context).size;
    return FutureBuilder<Response>(
      future: usersResponse,
      builder: (BuildContext futureContext, AsyncSnapshot<Response> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.active:
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Padding(
                padding: EdgeInsets.only(top: 52),
                child: Align(
                    child: Container(
                      child: CircularProgressIndicator(),
                    ),
                    alignment: Alignment.center));
          case ConnectionState.done:
            usersSource = UsersSource(
              onUpdate: onUpdate,
              buildContext: context,
              service: service,
              onRowSelect: (index) {},
              usersData: users,
            );
            return SingleChildScrollView(
              child: Container(
                width: size.width,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: PaginatedDataTable(
                    columnSpacing: 15,
                    actions: [
                      SizedBox(
                          height: 45.0,
                          child: RaisedButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Expanded(
                                        child: GenerateSignupTokenDialog(
                                            service: service));
                                  });
                            },
                            color: Colors.amber[700],
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(cardBorderRadius),
                            ),
                            child: Text(adminUsersGenerateSignupLink),
                            textColor: Colors.white,
                          )),
                      SizedBox(
                          width: 130,
                          height: 45.0,
                          child: RaisedButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return StatefulBuilder(
                                        builder: (context, setState) {
                                      return CreateUserDialog(
                                          service: service, onUpdate: onUpdate);
                                    });
                                  });
                            },
                            color: kPrimaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(cardBorderRadius),
                            ),
                            child: Text(adminUsersCreateUserButton),
                            textColor: Colors.white,
                          )),
                    ],
                    headingRowHeight: 80,
                    dataRowHeight: 80,
                    rowsPerPage: 10,
                    source: usersSource,
                    header: Text(
                      adminUsersTableTitle,
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    columns: _colGen(usersSource),
                  ),
                ),
              ),
            );
        }
        ;
      },
    );
  }

  List<DataColumn> _colGen(
    UsersSource _src,
    //UserDataNotifier _provider,
  ) =>
      <DataColumn>[
        DataColumn(
          label: Text(adminUsersImageCol),
        ),
        DataColumn(
          label: Text(adminUsersNameCol ),
        ),
        DataColumn(
          label: Text(adminUsersViewAccessCol),
        ),
        DataColumn(
          label: Text(adminUsersCreateAccessCol),
        ),
        DataColumn(
          label: Text(adminUsersPermissionAccessCol),
        ),
        DataColumn(
          label: Text(adminUsersDeleteAccessCol ),
        ),
        DataColumn(
          label: Text(adminUsersBlockAccessCol),
        ),
        DataColumn(
          label: Text(adminUsersBlockedCol),
        ),
        DataColumn(
          label: Text(adminUsersActionsCol),
        ),
      ];
}
