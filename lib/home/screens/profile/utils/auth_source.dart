import 'package:flutter/material.dart';
import 'package:hqs_desktop/generated/hqs-user-service/proto/hqs-user-service.pb.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

typedef OnRowSelect = void Function(int index);

class AuthHistorySource extends DataTableSource {
  final List<Auth> authData;
  final OnRowSelect onRowSelect;

  AuthHistorySource({@required this.authData, @required this.onRowSelect}) {
    assert(authData != null);
    assert(onRowSelect != null);

    authData.sort((a, b) {
      return b.lastUsedAt.toDateTime().compareTo(a.lastUsedAt.toDateTime());
    });
  }

  Future getAddress(double lat, double lon) async {}

  @override
  DataRow getRow(int index) {
    assert(index >= 0);

    if (index >= authData.length) {
      return null;
    }
    final auth = authData[index];

    DateTime lastUsedAt = auth.lastUsedAt.toDateTime();
    String formatlastUsedAt = DateFormat('yyyy-MM-dd-kk:mm').format(lastUsedAt);

    String address = "Unknown";
    if (auth.latitude != 0.0 && auth.longitude != 0.0) {
      getAddress(auth.latitude, auth.longitude).then((addr) {
        // set address to addr
        return addr;
      });
    }

    Text status = Text(
      'Invalid',
      style: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Colors.red[700],
      ),
    );
    if (auth.valid) {
      status = Text(
        'Valid',
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.green[500],
        ),
      );
    }

    return DataRow.byIndex(index: index, cells: <DataCell>[
      DataCell(Text(
        '$address',
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Colors.grey[800],
        ),
      )),
      DataCell(Text(
        '${auth.device}',
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Colors.grey[800],
        ),
      )),
      DataCell(Text(
        '$formatlastUsedAt',
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Colors.grey[800],
        ),
      )),
      DataCell(status),
      DataCell(
        auth.valid
            ? IconButton(
                hoverColor: Colors.transparent,
                splashColor: Colors.transparent,
                icon: const Icon(
                  Icons.delete,
                  color: Colors.blueGrey,
                ),
                onPressed: () => onRowSelect(index),
              )
            : Text(
                'Blocked',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.blueGrey,
                ),
              ),
      ),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => authData.length;

  @override
  int get selectedRowCount => 0;
}
