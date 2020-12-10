import 'package:flutter/material.dart';
import 'package:flushbar/flushbar.dart';
import 'package:hqs_desktop/generated/hqs-user-service/proto/hqs-user-service.pb.dart';
import 'package:hqs_desktop/screens/home/widgets/custom_dropdown_form_field.dart';
import 'package:hqs_desktop/service/hqs_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hqs_desktop/constants/constants.dart';
import 'package:flushbar/flushbar.dart';

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
                  switch (result) {
                    case "block":
                      _blockUserDetails(buildContext, user);
                      break;
                    case "edit":
                      _editUserDetails(buildContext, user);
                      break;
                    case "delete":
                      _deleteUserDetails(buildContext, user);
                      break;
                  }
                },
                itemBuilder: (BuildContext context) => getMenuItems(),
                child: Icon(
                  Icons.more_horiz,
                ),
              ),
            )
          : DataCell(Text("Not allowed")),
    ]);
  }

  List<PopupMenuEntry<String>> getMenuItems() {
    List<PopupMenuEntry<String>> items = List<PopupMenuEntry<String>>();
    if (service.curUser.allowPermission) {
      items.add(
        PopupMenuItem<String>(
          value: "edit",
          child: Container(
            width: 150,
            child: Text(
              'Edit',
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
          value: "block",
          child: Container(
            width: 150,
            child: Text(
              'Block / Unblock',
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
          value: "delete",
          child: Container(
            width: 150,
            child: Text(
              'Delete',
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

  void _deleteUserDetails(BuildContext c, User user) async =>
      await showDialog<bool>(
        context: c,
        builder: (_) => AlertDialog(
          title: Text(
            "Are you sure you want to delete " + user.name + "?",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  "Deleting a user is a NON-reversible action. This means that you will",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                  ),
                ),
                Text(
                  " not be able to get that users information back.",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                "Cancel",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: Colors.red,
                ),
              ),
              onPressed: () {
                Navigator.of(c, rootNavigator: true).pop();
              },
            ),
            TextButton(
              child: Text(
                "Delete",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: kPrimaryColor,
                ),
              ),
              onPressed: () {
                Navigator.of(c, rootNavigator: true).pop();
                service.deleteUser(user.id)
                  ..catchError((error) {
                    Flushbar(
                      title: "Something went wrong",
                      maxWidth: 800,
                      icon: Icon(
                        Icons.error_outline,
                        size: 28.0,
                        color: Colors.red[600],
                      ),
                      flushbarPosition: FlushbarPosition.TOP,
                      message:
                          "We could not delete ${user.name}. Please make sure that you have a valid wifi connection.",
                      margin: EdgeInsets.all(8),
                      borderRadius: 8,
                      duration: Duration(seconds: 5),
                    )..show(c);
                  }).then((value) {
                    onUpdate();
                    Flushbar(
                      title: "${user.name} was successfully deleted",
                      maxWidth: 800,
                      icon: Icon(
                        Icons.check_circle,
                        size: 28.0,
                        color: Colors.green,
                      ),
                      flushbarPosition: FlushbarPosition.TOP,
                      message: "We have successfully deleted ${user.name}.",
                      margin: EdgeInsets.all(8),
                      borderRadius: 8,
                      duration: Duration(seconds: 5),
                    )..show(Navigator.of(c, rootNavigator: true).context);
                    return value;
                  });
              },
            ),
          ],
        ),
      );

  void _blockUserDetails(BuildContext c, User user) async =>
      await showDialog<bool>(
        context: c,
        builder: (_) => AlertDialog(
          title: Text(
            "Are you sure you want to " +
                (user.blocked ? "unblock " : "block ") +
                "${user.name}?",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  "When blocking a user, that user will NOT be able to",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                  ),
                ),
                Text(
                  "access anything in the system - not even his/her own account.",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                  ),
                ),
                Text(
                  "You can always unblock a user after blocking him/her.",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                "Cancel",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: Colors.red,
                ),
              ),
              onPressed: () {
                Navigator.of(c, rootNavigator: true).pop();
              },
            ),
            TextButton(
              child: Text(
                user.blocked ? "Unblock" : "Block",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: kPrimaryColor,
                ),
              ),
              onPressed: () {
                Navigator.of(c, rootNavigator: true).pop();
                service.blockUser(user)
                  ..catchError((error) {
                    Flushbar(
                      title: "Something went wrong",
                      maxWidth: 800,
                      icon: Icon(
                        Icons.error_outline,
                        size: 28.0,
                        color: Colors.red[600],
                      ),
                      flushbarPosition: FlushbarPosition.TOP,
                      message: "We could " +
                          (user.blocked ? "unblock" : "block") +
                          " ${user.name}. Please make sure that you have a valid wifi connection.",
                      margin: EdgeInsets.all(8),
                      borderRadius: 8,
                      duration: Duration(seconds: 5),
                    )..show(c);
                  }).then((value) {
                    onUpdate();
                    Flushbar(
                      title: "${user.name} was successfully " +
                          (user.blocked ? "unblocked" : "blocked"),
                      maxWidth: 800,
                      icon: Icon(
                        Icons.check_circle,
                        size: 28.0,
                        color: Colors.green,
                      ),
                      flushbarPosition: FlushbarPosition.TOP,
                      message: "We have successfully" +
                          (user.blocked ? "unblocked" : "blocked") +
                          " ${user.name}.",
                      margin: EdgeInsets.all(8),
                      borderRadius: 8,
                      duration: Duration(seconds: 5),
                    )..show(Navigator.of(c, rootNavigator: true).context);
                    return value;
                  });
              },
            ),
          ],
        ),
      );

  void _editUserDetails(BuildContext c, User user) async {
    final _formKey = GlobalKey<FormState>();
    bool allowView = user.allowView;
    bool allowCreate = user.allowCreate;
    bool allowDelete = user.allowDelete;
    bool allowPermission = user.allowPermission;
    bool allowBlock = user.allowBlock;
    await showDialog<bool>(
        context: c,
        builder: (_) => StatefulBuilder(builder: (context, setState) {
              return AlertDialog(
                  title: Text(
                    "Edit ${user.name}'s Permissions  ",
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[900],
                    ),
                  ),
                  content: Container(
                    width: 800,
                    height: 550,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "The system requires valid access codes. To grant create access, one has to to grant ${user.name} view and permission access as well. To grant delete, permission or block access, one also has to grant ${user.name} view access.",
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 32),
                        Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Flexible(
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text("View Access"),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            CustomDromDownMenu(
                                              validator: (value) {
                                                return null;
                                              },
                                              defaultBorderColor:
                                                  Colors.grey[200],
                                              hintText: 'View Access',
                                              items: [
                                                DropdownMenuItem(
                                                  child: Text('true'),
                                                  value: true,
                                                ),
                                                DropdownMenuItem(
                                                  child: Text('false'),
                                                  value: false,
                                                ),
                                              ],
                                              value: allowView,
                                              onChanged: (value) {
                                                setState(() {
                                                  allowView = value;
                                                });
                                              },
                                            ),
                                          ]),
                                    ),
                                    SizedBox(width: 18),
                                    Flexible(
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text("Create Access"),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            CustomDromDownMenu(
                                              validator: (value) {},
                                              defaultBorderColor:
                                                  Colors.grey[200],
                                              hintText: 'Create Access',
                                              items: [
                                                DropdownMenuItem(
                                                  child: Text('true'),
                                                  value: true,
                                                ),
                                                DropdownMenuItem(
                                                  child: Text('false'),
                                                  value: false,
                                                ),
                                              ],
                                              value: allowCreate,
                                              onChanged: (value) {
                                                setState(() {
                                                  allowCreate = value;
                                                });
                                              },
                                            ),
                                          ]),
                                    ),
                                  ]),
                              SizedBox(height: 28),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Flexible(
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text("Permission Access"),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            CustomDromDownMenu(
                                              validator: (value) {},
                                              defaultBorderColor:
                                                  Colors.grey[200],
                                              hintText: 'Permission Access',
                                              items: [
                                                DropdownMenuItem(
                                                  child: Text('true'),
                                                  value: true,
                                                ),
                                                DropdownMenuItem(
                                                  child: Text('false'),
                                                  value: false,
                                                ),
                                              ],
                                              value: allowPermission,
                                              onChanged: (value) {
                                                setState(() {
                                                  allowPermission = value;
                                                });
                                              },
                                            ),
                                          ]),
                                    ),
                                    SizedBox(width: 18),
                                    Flexible(
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text("Delete Access"),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            CustomDromDownMenu(
                                              validator: (value) {},
                                              defaultBorderColor:
                                                  Colors.grey[200],
                                              hintText: 'Delte Access',
                                              items: [
                                                DropdownMenuItem(
                                                  child: Text('true'),
                                                  value: true,
                                                ),
                                                DropdownMenuItem(
                                                  child: Text('false'),
                                                  value: false,
                                                ),
                                              ],
                                              value: allowDelete,
                                              onChanged: (value) {
                                                setState(() {
                                                  allowDelete = value;
                                                });
                                              },
                                            ),
                                          ]),
                                    ),
                                  ]),
                              SizedBox(height: 28),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Flexible(
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text("Block Access"),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            CustomDromDownMenu(
                                              validator: (value) {},
                                              defaultBorderColor:
                                                  Colors.grey[200],
                                              hintText: 'Block Access',
                                              items: [
                                                DropdownMenuItem(
                                                  child: Text('true'),
                                                  value: true,
                                                ),
                                                DropdownMenuItem(
                                                  child: Text('false'),
                                                  value: false,
                                                ),
                                              ],
                                              value: allowBlock,
                                              onChanged: (value) {
                                                setState(() {
                                                  allowBlock = value;
                                                });
                                              },
                                            ),
                                          ]),
                                    ),
                                  ]),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: Text(
                        "Close",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: Colors.red,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(buildContext, rootNavigator: true).pop();
                      },
                    ),
                    TextButton(
                      child: Text(
                        "Update",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: kPrimaryColor,
                        ),
                      ),
                      onPressed: () {
                        service
                            .updateUsersPermissions(
                          user.id,
                          allowView,
                          allowCreate,
                          allowPermission,
                          allowDelete,
                          allowBlock,
                        )
                            .catchError((error) {
                          Flushbar(
                            title: "Something went wrong",
                            maxWidth: 800,
                            icon: Icon(
                              Icons.error_outline,
                              size: 28.0,
                              color: Colors.red[600],
                            ),
                            flushbarPosition: FlushbarPosition.TOP,
                            message: "Could not update the allowances of " +
                                user.name,
                            margin: EdgeInsets.all(8),
                            borderRadius: 8,
                            duration: Duration(seconds: 5),
                          )..show(context);
                        }).then((value) {
                          onUpdate();
                          Navigator.of(buildContext, rootNavigator: true).pop();
                          Flushbar(
                            maxWidth: 800,
                            title: "Successfully updated allowances",
                            icon: Icon(
                              Icons.info_outline,
                              size: 28.0,
                              color: Colors.green[500],
                            ),
                            flushbarPosition: FlushbarPosition.TOP,
                            message: "Successfully updated the allowances of " +
                                user.name,
                            margin: EdgeInsets.all(8),
                            borderRadius: 8,
                            duration: Duration(seconds: 5),
                          )..show(context);
                        });
                      },
                    ),
                  ]);
            }));
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => usersData.length;

  @override
  int get selectedRowCount => 0;
}
