import 'package:flutter/material.dart';
import 'package:dart_hqs/hqs_user_service.pb.dart';
import 'package:hqs_desktop/theme/theme.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

typedef OnRowSelect = void Function(int index);

class AuthHistorySource extends DataTableSource {
  final List<Auth> authData;
  final OnRowSelect onRowSelect;
  final HqsTheme theme;
  AuthHistorySource(
      {@required this.authData,
      @required this.onRowSelect,
      @required this.theme}) {
    assert(authData != null);
    assert(onRowSelect != null);
    assert(theme != null);

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
        color: theme.dangerColor(),
      ),
    );
    if (auth.valid) {
      status = Text(
        'Valid',
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: theme.successColor(),
        ),
      );
    }

    return DataRow.byIndex(
        index: index,

        cells: <DataCell>[
          DataCell(Text(
            '${auth.typeOf}',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: theme.textColor(),
            ),
          )),
          DataCell(Text(
            '${auth.device}',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: theme.textColor(),
            ),
          )),
          DataCell(Text(
            '$formatlastUsedAt',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: theme.textColor(),
            ),
          )),
          DataCell(status),
          DataCell(
            auth.valid
                ? IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: theme.primaryColor(),
                    ),
                    onPressed: () => onRowSelect(index),
                  )
                : Text(
                    'Blocked',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: theme.textColor(),
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
