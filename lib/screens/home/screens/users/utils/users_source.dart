import 'package:flutter/material.dart';
import 'package:hqs_desktop/generated/hqs-user-service/proto/hqs-user-service.pb.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hqs_desktop/constants/constants.dart';

typedef OnRowSelect = void Function(int index);

class UsersSource extends DataTableSource {
  final List<User> usersData;
  final OnRowSelect onRowSelect;

  UsersSource({@required this.usersData, @required this.onRowSelect}) {
    assert(usersData != null);
    assert(onRowSelect != null);
  }

  Future getAddress(double lat, double lon) async {}

  @override
  DataRow getRow(int index) {
    assert(index >= 0);

    if (index >= usersData.length) {
      return null;
    }
    final user = usersData[index];

    DateTime createdAt = user.createdAt.toDateTime();
    String formatCreatedAt = DateFormat('yyyy-MM-dd-kk:mm').format(createdAt);

    return DataRow.byIndex(index: index, cells: <DataCell>[
      DataCell(Text(
        '${user.name}',
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Colors.grey[800],
        ),
      )),
      DataCell(Text(
        '$formatCreatedAt',
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
          color: user.allowView ? kValidColor: kInvalidColor,
        ),
      )),
      DataCell(Text(
        '${user.allowCreate}',
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: user.allowCreate ? kValidColor: kInvalidColor,
        ),
      )),
      DataCell(Text(
        '${user.allowPermission}',
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: user.allowPermission ? kValidColor: kInvalidColor,
        ),
      )),
      DataCell(Text(
        '${user.allowDelete}',
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: user.allowDelete ? kValidColor: kInvalidColor,
        ),
      )),
      DataCell(Text(
        '${user.allowBlock}',
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: user.allowBlock ? kValidColor: kInvalidColor,
        ),
      )),
      DataCell(Text(
        '${user.blocked}',
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: user.blocked ? kValidColor: kInvalidColor,
        ),
      )),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => usersData.length;

  @override
  int get selectedRowCount => 0;
}
