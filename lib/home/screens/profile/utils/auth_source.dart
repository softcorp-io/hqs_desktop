import 'package:flutter/material.dart';
import 'package:dart_hqs/hqs_user_service.pb.dart';
import 'package:hqs_desktop/theme/constants.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

typedef OnRowSelect = void Function(int index);

class AuthHistorySource extends DataTableSource {
  final List<Auth> authData;
  final OnRowSelect onRowSelect;
  final BuildContext context;
  AuthHistorySource({
    @required this.authData,
    @required this.onRowSelect,
    @required this.context,
  }) {
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
        color: Theme.of(context).errorColor,
      ),
    );
    if (auth.valid) {
      status = Text(
        'Valid',
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: successColor,
        ),
      );
    }

    return DataRow.byIndex(index: index, cells: <DataCell>[
      DataCell(Text(
        '${auth.typeOf}',
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      )),
      DataCell(Text(
        '${auth.device}',
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      )),
      DataCell(Text(
        '$formatlastUsedAt',
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      )),
      DataCell(status),
      DataCell(
        auth.valid
            ? IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Theme.of(context).primaryColor,
                ),
                onPressed: () => onRowSelect(index),
              )
            : Text(
                'Blocked',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
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
