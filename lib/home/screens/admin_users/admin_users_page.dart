import 'package:flutter/material.dart';
import 'package:hqs_desktop/constants/constants.dart';
import 'package:dart_hqs/hqs_user_service.pb.dart';
import 'package:hqs_desktop/home/screens/admin_users/constants/text.dart';
import 'package:hqs_desktop/home/screens/admin_users/utils/users_source.dart';
import 'package:hqs_desktop/home/screens/admin_users/widgets/create_user_dialog.dart';
import 'package:hqs_desktop/home/screens/admin_users/widgets/generate_signup_token_dialog.dart';
import 'package:hqs_desktop/home/widgets/custom_navigationrail.dart';
import 'package:hqs_desktop/service/hqs_user_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hqs_desktop/theme/theme.dart';

/// This is the stateless widget that the main application instantiates.
class UsersPage extends StatefulWidget {
  final HqsService service;
  final HqsTheme theme;
  UsersPage({@required this.service, @required this.theme})
      : assert(service != null),
        assert(theme != null);

  @override
  _UsersPageState createState() =>
      _UsersPageState(service: service, theme: theme);
}

class _UsersPageState extends State<UsersPage> {
  final HqsService service;
  final HqsTheme theme;
  Future<Response> usersResponse;
  List<User> users;
  _UsersPageState({@required this.service, @required this.theme}) {
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
              theme: theme,
              onUpdate: onUpdate,
              buildContext: context,
              service: service,
              onRowSelect: (index) {},
              usersData: users,
            );
            return Container(
              width: size.width,
              child: SingleChildScrollView(
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
                                              theme: theme, service: service));
                                    });
                              },
                              color: theme.successColor(),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(cardBorderRadius),
                              ),
                              child: Text(adminUsersGenerateSignupLink),
                              textColor: theme.buttonTextColor(),
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
                                            theme: theme,
                                            service: service,
                                            onUpdate: onUpdate);
                                      });
                                    });
                              },
                              color: theme.primaryColor(),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(cardBorderRadius),
                              ),
                              child: Text(adminUsersCreateUserButton),
                              textColor: theme.buttonTextColor(),
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
                          color: theme.titleColor(),
                        ),
                      ),
                      columns: _colGen(usersSource),
                    ),
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
          label: Text(adminUsersNameCol),
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
          label: Text(adminUsersDeleteAccessCol),
        ),
        DataColumn(
          label: Text(adminUsersBlockAccessCol),
        ),
        DataColumn(
          label: Text(adminUsersResetAccessCol),
        ),
        DataColumn(
          label: Text(adminUsersBlockedCol),
        ),
        DataColumn(
          label: Text(adminUsersActionsCol),
        ),
      ];
}
