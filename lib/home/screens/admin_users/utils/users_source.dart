import 'package:flutter/material.dart';
import 'package:hqs_desktop/generated/hqs-user-service/proto/hqs-user-service.pb.dart';
import 'package:hqs_desktop/home/screens/admin_users/constants/text.dart';
import 'package:hqs_desktop/home/screens/admin_users/widgets/block_user_dialog.dart';
import 'package:hqs_desktop/home/screens/admin_users/widgets/delete_user_dialog.dart';
import 'package:hqs_desktop/home/screens/admin_users/widgets/edit_user_dialog.dart';
import 'package:hqs_desktop/service/hqs_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hqs_desktop/constants/constants.dart';

typedef OnRowSelect = void Function(int index);

class UsersSource extends DataTableSource {
  final List<User> usersData;
  final OnRowSelect onRowSelect;
  final HqsService service;
  final BuildContext buildContext;
  final Function onUpdate;

  UsersSource(
      {@required this.usersData,
      @required this.onRowSelect,
      @required this.onUpdate,
      @required this.buildContext,
      @required this.service}) {
    assert(usersData != null);
    assert(service != null);
    assert(onUpdate != null);
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
      DataCell(CircleAvatar(
        backgroundColor: Colors.grey[800],
        backgroundImage: NetworkImage(user.image),
      )),
      DataCell(Text(
        '${user.name}',
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Colors.grey[800],
        ),
      )),
      DataCell(Text(
        '${user.allowView}',
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: user.allowView ? kValidColor : kInvalidColor,
        ),
      )),
      DataCell(Text(
        '${user.allowCreate}',
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: user.allowCreate ? kValidColor : kInvalidColor,
        ),
      )),
      DataCell(Text(
        '${user.allowPermission}',
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: user.allowPermission ? kValidColor : kInvalidColor,
        ),
      )),
      DataCell(Text(
        '${user.allowDelete}',
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: user.allowDelete ? kValidColor : kInvalidColor,
        ),
      )),
      DataCell(Text(
        '${user.allowBlock}',
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: user.allowBlock ? kValidColor : kInvalidColor,
        ),
      )),
      DataCell(Text(
        '${user.blocked}',
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: user.blocked ? kValidColor : kInvalidColor,
        ),
      )),
      service.curUser.allowBlock ||
              service.curUser.allowDelete ||
              service.curUser.allowPermission
          ? DataCell(
              PopupMenuButton<String>(
                onSelected: (String result) {
                  switch (result.toLowerCase()) {
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
                            return EditUserDialog(
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
                child: Icon(
                  Icons.more_horiz,
                ),
              ),
            )
          : DataCell(Text(userSourceActionNotAllowed)),
    ]);
  }

  List<PopupMenuEntry<String>> getMenuItems() {
    List<PopupMenuEntry<String>> items = List<PopupMenuEntry<String>>();
    if (service.curUser.allowPermission) {
      items.add(
        PopupMenuItem<String>(
          value: userSourceActionEditValue,
          child: Container(
            width: 150,
            child: Text(
              userSourceActionEditText,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
          ),
        ),
      );
    }
    if (service.curUser.allowBlock) {
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
                color: Colors.black,
              ),
            ),
          ),
        ),
      );
    }
    if (service.curUser.allowDelete) {
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
                color: Colors.red[600],
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
