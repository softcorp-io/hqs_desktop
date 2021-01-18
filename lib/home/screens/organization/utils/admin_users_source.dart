import 'package:flutter/material.dart';
import 'package:dart_hqs/hqs_user_service.pb.dart';
import 'package:hqs_desktop/home/pages/user_page.dart';
import 'package:hqs_desktop/home/screens/organization/constants/text.dart';
import 'package:hqs_desktop/home/screens/organization/widgets/block_user_dialog.dart';
import 'package:hqs_desktop/home/screens/organization/widgets/delete_user_dialog.dart';
import 'package:hqs_desktop/home/screens/organization/widgets/edit_users_privileges_dialog.dart';
import 'package:hqs_desktop/home/screens/organization/widgets/reset_password_dialog.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hqs_desktop/service/hqs_service.dart';
import 'package:hqs_desktop/theme/constants.dart';
import 'package:intl/intl.dart';
import 'package:dart_hqs/hqs_privilege_service.pbgrpc.dart' as privilegeService;

typedef OnRowSelect = void Function(int index);

class AdminUsersSource extends DataTableSource {
  final List<User> usersData;
  final OnRowSelect onRowSelect;
  final HqsService service;
  final BuildContext buildContext;
  final Function onUpdate;
  final Function navigateToProfile;
  final List<privilegeService.Privilege> privileges;
  final BuildContext context;
  AdminUsersSource(
      {@required this.usersData,
      @required this.onRowSelect,
      @required this.context,
      @required this.privileges,
      @required this.onUpdate,
      @required this.navigateToProfile,
      @required this.buildContext,
      @required this.service}) {
    assert(usersData != null);
    assert(context != null);
    assert(navigateToProfile != null);
    assert(service != null);
    assert(onUpdate != null);
    assert(privileges != null);
    assert(buildContext != null);
    assert(onRowSelect != null);
  }

  @override
  DataRow getRow(int index) {
    assert(index >= 0);

    if (index >= usersData.length) {
      return null;
    }
    final user = usersData[index];
    return DataRow.byIndex(index: index, cells: <DataCell>[
      DataCell(
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UserPage(
                  service: service,
                  user: user,
                  navigateToProfile: navigateToProfile,
                ),
              ),
            );
          },
          child: Container(
            constraints: BoxConstraints(maxWidth: 300),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black38,
                        blurRadius: 0.5,
                        offset: Offset(0.0, 0.5),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(user.image),
                    backgroundColor: Colors.transparent,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Text(
                        '${user.name}',
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context).primaryColor),
                      ),
                    ),
                    Text(
                      '${user.email}',
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).primaryColor),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      DataCell(
        Text(
          privileges.firstWhere((priv) => priv.id == user.privilegeID).name,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      DataCell(
        Text(
          user.updatedAt == null
              ? new DateFormat("yyyy-MM-dd-kk:mm")
                  .format(user.updatedAt.toDateTime())
              : new DateFormat("yyyy-MM-dd-kk:mm")
                  .format(user.createdAt.toDateTime()),
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      DataCell(
        Text(
          '${user.blocked}',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: user.blocked ? successColor : Theme.of(context).errorColor,
          ),
        ),
      ),
      DataCell(
        service.curPrivilege.blockUser ||
                service.curPrivilege.createUser ||
                service.curPrivilege.deleteUser ||
                service.curPrivilege.sendResetPasswordEmail
            ? Align(
                alignment: Alignment.centerRight,
                child: Container(
                  width: 100,
                  height: 40,
                  child: PopupMenuButton<String>(
                    onSelected: (String result) {
                      switch (result.toLowerCase()) {
                        case userSourceActionViewValue:
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UserPage(
                                      service: service,
                                      user: user,
                                      navigateToProfile: navigateToProfile,
                                    )),
                          );
                          break;
                        case userSourceActionBlockValue:
                          showDialog(
                              context: buildContext,
                              builder: (BuildContext context) {
                                return BlockUserDialog(
                                  service: service,
                                  buildContext: buildContext,
                                  onUpdate: onUpdate,
                                  user: user,
                                );
                              });
                          break;
                        case userSourceActionEditValue:
                          showDialog(
                              context: buildContext,
                              builder: (BuildContext context) {
                                return EditUsersPrivilegesDialog(
                                    service: service,
                                    privileges: privileges,
                                    user: user,
                                    onUpdate: onUpdate);
                              });
                          break;
                        case userSourceActionResetValue:
                          showDialog(
                              context: buildContext,
                              builder: (BuildContext context) {
                                return ResetPasswordDialog(
                                  service: service,
                                  buildContext: buildContext,
                                  onUpdate: onUpdate,
                                  user: user,
                                );
                              });
                          break;
                        case userSourceActionDeleteValue:
                          showDialog(
                              context: buildContext,
                              builder: (BuildContext context) {
                                return DeleteUserDialog(
                                  service: service,
                                  buildContext: buildContext,
                                  onUpdate: onUpdate,
                                  user: user,
                                );
                              });
                          break;
                      }
                    },
                    itemBuilder: (BuildContext context) => getMenuItems(),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Actions",
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
                        Icon(
                          Icons.arrow_drop_down,
                          color: Theme.of(context).primaryColor,
                        )
                      ],
                    ),
                  ),
                ),
              )
            : Align(child: Text("Not allowed"), alignment: Alignment.center),
      ),
    ]);
  }

  List<PopupMenuEntry<String>> getMenuItems() {
    List<PopupMenuEntry<String>> items = List<PopupMenuEntry<String>>();
    if (service.curPrivilege.managePrivileges) {
      items.add(
        PopupMenuItem<String>(
          value: userSourceActionEditValue,
          child: Container(
            width: 150,
            child: Text(
              "Edit Privileges",
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      );
    }
    if (service.curPrivilege.blockUser) {
      items.add(
        PopupMenuItem<String>(
          value: userSourceActionBlockValue,
          child: Container(
            width: 150,
            child: Text(
              userSourceActionBlockText,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      );
    }
    if (service.curPrivilege.sendResetPasswordEmail) {
      items.add(
        PopupMenuItem<String>(
          value: userSourceActionResetValue,
          child: Container(
            width: 150,
            child: Text(
              userSourceActionResetText,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      );
    }
    if (service.curPrivilege.deleteUser) {
      items.add(
        PopupMenuItem<String>(
          value: userSourceActionDeleteValue,
          child: Container(
            width: 150,
            child: Text(
              userSourceActionDeleteText,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Theme.of(context).errorColor,
              ),
            ),
          ),
        ),
      );
    }
    return items;
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => usersData.length;

  @override
  int get selectedRowCount => 0;
}
