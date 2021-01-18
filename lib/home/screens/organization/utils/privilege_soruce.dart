import 'package:flutter/material.dart';
import 'package:hqs_desktop/home/screens/organization/constants/text.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hqs_desktop/home/screens/organization/widgets/delete_privilege_dialog.dart';
import 'package:hqs_desktop/home/screens/organization/widgets/edit_privilege_dialog.dart';
import 'package:hqs_desktop/service/hqs_service.dart';
import 'package:hqs_desktop/theme/constants.dart';
import 'package:dart_hqs/hqs_privilege_service.pbgrpc.dart' as privilegeService;

typedef OnRowSelect = void Function(int index);

class PrivilegeSource extends DataTableSource {
  final OnRowSelect onRowSelect;
  final HqsService service;
  final BuildContext buildContext;
  final Function onUpdate;
  final List<privilegeService.Privilege> privileges;
  final BuildContext context;

  PrivilegeSource(
      {@required this.onRowSelect,
      @required this.context,
      @required this.privileges,
      @required this.onUpdate,
      @required this.buildContext,
      @required this.service}) {
    assert(context != null);
    assert(service != null);
    assert(onUpdate != null);
    assert(privileges != null);
    assert(buildContext != null);
    assert(onRowSelect != null);
  }

  @override
  DataRow getRow(int index) {
    assert(index >= 0);

    if (index >= privileges.length) {
      return null;
    }
    final privilege = privileges[index];
    return DataRow.byIndex(index: index, cells: <DataCell>[
      DataCell(
        Text(
          '${privilege.name}',
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      DataCell(
        Text(
          '${privilege.viewAllUsers}',
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: privilege.viewAllUsers ? successColor : dangerColor,
          ),
        ),
      ),
      DataCell(
        Text(
          '${privilege.createUser}',
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: privilege.createUser ? successColor : dangerColor,
          ),
        ),
      ),
      DataCell(
        Text(
          '${privilege.managePrivileges}',
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: privilege.managePrivileges ? successColor : dangerColor,
          ),
        ),
      ),
      DataCell(
        Text(
          '${privilege.deleteUser}',
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: privilege.deleteUser ? successColor : dangerColor,
          ),
        ),
      ),
      DataCell(
        Text(
          '${privilege.blockUser}',
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: privilege.blockUser ? successColor : dangerColor,
          ),
        ),
      ),
      DataCell(
        Text(
          '${privilege.sendResetPasswordEmail}',
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: privilege.sendResetPasswordEmail ? successColor : dangerColor,
          ),
        ),
      ),
      DataCell(
        service.curPrivilege.managePrivileges &&
                (!privilege.root && !privilege.default_9)
            ? Align(
                alignment: Alignment.centerRight,
                child: Container(
                  width: 100,
                  height: 40,
                  child: PopupMenuButton<String>(
                    onSelected: (String result) {
                      switch (result.toLowerCase()) {
                        case "edit":
                        showDialog(
                              context: buildContext,
                              builder: (BuildContext context) {
                                return EditPrivilegeDialog(
                                  service: service,
                                  onUpdate: onUpdate,
                                  privilege: privilege,
                                );
                              });
                          break;
                        case "delete":
                          showDialog(
                              context: buildContext,
                              builder: (BuildContext context) {
                                return DeletePrivilegeDialog(
                                  service: service,
                                  buildContext: buildContext,
                                  onUpdate: onUpdate,
                                  privilege: privilege,
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
            : Align(
                child: Text("Not allowed"),
                alignment: Alignment.center,
              ),
      ),
    ]);
  }

  List<PopupMenuEntry<String>> getMenuItems() {
    List<PopupMenuEntry<String>> items = List<PopupMenuEntry<String>>();
    if (service.curPrivilege.managePrivileges) {
      items.addAll(
        [
          PopupMenuItem<String>(
            value: "edit",
            child: Container(
              width: 150,
              child: Text(
                "Edit",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          PopupMenuItem<String>(
            value: "delete",
            child: Container(
              width: 150,
              child: Text(
                "Delete",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).errorColor,
                ),
              ),
            ),
          ),
        ],
      );
    }
    return items;
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => privileges.length;

  @override
  int get selectedRowCount => 0;
}
