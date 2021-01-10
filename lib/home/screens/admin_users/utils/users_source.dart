import 'package:flutter/material.dart';
import 'package:dart_hqs/hqs_user_service.pb.dart';
import 'package:hqs_desktop/home/screens/admin_users/constants/text.dart';
import 'package:hqs_desktop/home/screens/admin_users/widgets/block_user_dialog.dart';
import 'package:hqs_desktop/home/screens/admin_users/widgets/delete_user_dialog.dart';
import 'package:hqs_desktop/home/screens/admin_users/widgets/edit_user_dialog.dart';
import 'package:hqs_desktop/home/screens/admin_users/widgets/reset_password_dialog.dart';
import 'package:hqs_desktop/home/screens/admin_users/widgets/view_user_dialog.dart';
import 'package:hqs_desktop/service/hqs_user_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hqs_desktop/theme/constants.dart';

typedef OnRowSelect = void Function(int index);

class UsersSource extends DataTableSource {
  final List<User> usersData;
  final OnRowSelect onRowSelect;
  final HqsService service;
  final BuildContext buildContext;
  final Function onUpdate;
  final BuildContext context;
  UsersSource(
      {@required this.usersData,
      @required this.onRowSelect,
      @required this.context,
      @required this.onUpdate,
      @required this.buildContext,
      @required this.service}) {
    assert(usersData != null);
    assert(context != null);
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
        backgroundColor: Colors.transparent,
        backgroundImage: NetworkImage(user.image),
      )),
      DataCell(Text(
        '${user.name}',
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      )),
      DataCell(Text(
        '${user.allowView}',
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: user.allowView
              ? successColor
              : Theme.of(context).errorColor,
        ),
      )),
      DataCell(Text(
        '${user.allowCreate}',
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: user.allowCreate
              ? successColor
              : Theme.of(context).errorColor,
        ),
      )),
      DataCell(Text(
        '${user.allowPermission}',
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: user.allowPermission
              ? successColor
              : Theme.of(context).errorColor,
        ),
      )),
      DataCell(Text(
        '${user.allowDelete}',
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: user.allowDelete
              ? successColor
              : Theme.of(context).errorColor,
        ),
      )),
      DataCell(Text(
        '${user.allowBlock}',
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: user.allowBlock
              ? successColor
              : Theme.of(context).errorColor,
        ),
      )),
      DataCell(Text(
        '${user.allowResetPassword}',
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: user.allowResetPassword
              ? successColor
              : Theme.of(context).errorColor,
        ),
      )),
      DataCell(Text(
        '${user.blocked}',
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: user.blocked
              ? successColor
              : Theme.of(context).errorColor,
        ),
      )),
      service.curUser.allowBlock ||
              service.curUser.allowView ||
              service.curUser.allowDelete ||
              service.curUser.allowResetPassword ||
              service.curUser.allowPermission
          ? DataCell(
              PopupMenuButton<String>(
                onSelected: (String result) {
                  switch (result.toLowerCase()) {
                    case userSourceActionViewValue:
                      showDialog(
                          context: buildContext,
                          builder: (BuildContext context) {
                            return ViewUserDialog(
                              service: service,
                              buildContext: buildContext,
                              user: user,
                            );
                          });
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
                            return EditUserDialog(
                              service: service,
                              buildContext: buildContext,
                              onUpdate: onUpdate,
                              user: user,
                            );
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
    if (service.curUser.allowView) {
      items.add(
        PopupMenuItem<String>(
          value: userSourceActionViewValue,
          child: Container(
            width: 150,
            child: Text(
              userSourceActionViewText,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      );
    }
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
              ),
            ),
          ),
        ),
      );
    }
    if (service.curUser.allowResetPassword) {
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
