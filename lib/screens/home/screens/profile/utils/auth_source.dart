import 'package:flutter/material.dart';
import 'package:hqs_desktop/generated/hqs-user-service/proto/hqs-user-service.pb.dart';

typedef OnRowSelect = void Function(int index);

class AuthHistorySource extends DataTableSource{
  final List<Auth> authData;
  // final OnRowSelect onRowSelect;

  AuthHistorySource({@required this.authData, /*@required this.onRowSelect */})
    : assert(authData != null)/*,
      assert(onRowSelect != null)*/;
    
    @override
    DataRow getRow(int index){
      assert(index >= 0);

      if (index >= authData.length){
        return null;
      }
      final auth = authData[index];
      return DataRow.byIndex(
        index: index,
        cells: <DataCell>[
                  DataCell(Text('${auth.createdAt}')),
        DataCell(Text('${auth.expiresAt}')),
        DataCell(Text('${auth.latitude}')),
        DataCell(Text('${auth.longitude}')),
        DataCell(Text('${auth.tokenID}')),
/*         DataCell(
          IconButton(
            hoverColor: Colors.transparent,
            splashColor: Colors.transparent,
            icon: const Icon(Icons.details),
            // onPressed: () => onRowSelect(index),
          ),
        ), */
        ]
      );
    }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => authData.length;

  @override
  int get selectedRowCount => 0;

}