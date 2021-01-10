import 'package:flutter/material.dart';
import 'package:hqs_desktop/constants/constants.dart';
import 'package:dart_hqs/hqs_user_service.pb.dart';
import 'package:hqs_desktop/home/screens/profile/constants/constants.dart';
import 'package:hqs_desktop/home/screens/profile/constants/text.dart';
import 'package:hqs_desktop/home/screens/profile/utils/auth_source.dart';
import 'package:hqs_desktop/home/widgets/custom_flushbar_error.dart';
import 'package:hqs_desktop/home/widgets/custom_flushbar_success.dart';
import 'package:hqs_desktop/service/hqs_user_service.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileAuthHistory extends StatefulWidget {
  final HqsService service;
  ProfileAuthHistory({@required this.service}) : assert(service != null);

  @override
  _ProfileAuthHistoryState createState() => _ProfileAuthHistoryState(
        service: service,
      );
}

class _ProfileAuthHistoryState extends State<ProfileAuthHistory> {
  // constructor parameters
  final HqsService service;
  Future<AuthHistory> authHistoryResponse;
  AuthHistory authHistory;

  _ProfileAuthHistoryState({
    @required this.service,
  }) {
    assert(service != null);
    this.authHistoryResponse =
        service.getCurrentUserAuthHistory().then((value) {
      authHistory = value;
      return authHistory;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
        child: FutureBuilder<AuthHistory>(
            future: authHistoryResponse,
            builder:
                (BuildContext context, AsyncSnapshot<AuthHistory> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.active:
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return Padding(
                      padding: EdgeInsets.only(top: profileImageRadius / 2),
                      child: Align(
                          child: Container(
                            child: CircularProgressIndicator(),
                          ),
                          alignment: Alignment.center));
                case ConnectionState.done:
                  final authSource = AuthHistorySource(
                    context: context,
                    onRowSelect: (index) => _blockTokenDetails(
                        context, authHistory.authHistory[index]),
                    authData: authHistory.authHistory,
                  );
                  return Container(
                      width: size.width,
                      height: 650,
                      child: PaginatedDataTable(
                        actions: [
                          SizedBox(
                              width: 130,
                              height: 35.0,
                              child: RaisedButton(
                                onPressed: () {
                                  _blockAllTokensDetails(context);
                                },
                                color: Theme.of(context).errorColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(cardBorderRadius),
                                ),
                                child:
                                    Text(usersTokenCardBlockAllTokensBtnText),
                              )),
                        ],
                        headingRowHeight: 80,
                        dataRowHeight: 80,
                        rowsPerPage: 5,
                        source: authSource,
                        header: Text(
                          usersTokenCardTitle,
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        columns: _colGen(authSource),
                      ));
              }
              ;
            }));
  }

  List<DataColumn> _colGen(
    AuthHistorySource _src,
    //UserDataNotifier _provider,
  ) =>
      <DataColumn>[
        DataColumn(
          label: Text(usersTokenCardTypeCol),
        ),
        DataColumn(
          label: Text(usersTokenCardDeviceCol),
        ),
        DataColumn(
          label: Text(usersTokenCardLastUsedCol),
        ),
        DataColumn(
          label: Text(usersTokenCardStatusCol),
        ),
        DataColumn(
          label: Text(usersTokenCardActionsCol),
        ),
      ];

  void _blockTokenDetails(BuildContext c, Auth auth) async =>
      await showDialog<bool>(
        context: c,
        builder: (_) => AlertDialog(
          title: Text(
            blockTokenCardTitle,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  blockTokenCardTextOne,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                Text(
                  blockTokenCardTextTwo,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                Text(
                  blockTokenCardTextThree,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                blockTokenCardCancelBtnText,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: Theme.of(context).errorColor,
                ),
              ),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
            ),
            TextButton(
              child: Text(
                blockTokenCardBlockBtnText,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
                service.blockTokenByID(auth.tokenID)
                  ..catchError((error) {
                    CustomFlushbarError(
                            title: blockTokenCardExceptionTitle,
                            body: blockTokenCardExceptionText,
                            context: context)
                        .getFlushbar()
                        .show(context);
                  }).then((token) {
                    CustomFlushbarSuccess(
                            title: blockTokenCardSuccessTitle,
                            body: blockTokenCardSuccessText,
                            context: context)
                        .getFlushbar()
                        .show(context);

                    setState(() {
                      auth.valid = false;
                    });
                    return token;
                  });
              },
            ),
          ],
        ),
      );

  void _blockAllTokensDetails(BuildContext c) async => await showDialog<bool>(
        context: c,
        builder: (_) => AlertDialog(
          title: Text(
            "Block All Tokens?",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  "You are about to block ALL your tokens. If you suspect that someone",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                Text(
                  "has misused your account, you should change your password as well.",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                Text(
                  "After blocking all tokens, you will be logged out since you don't",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                Text(
                  "have a valid token anymore.",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
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
                  color: Theme.of(context).errorColor,
                ),
              ),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
              },
            ),
            TextButton(
              child: Text(
                "Block All",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
                service.blockAllUsersTokens()
                  ..catchError((error) {
                    CustomFlushbarError(
                            title: "Something went wrong",
                            body:
                                "We could not block all tokens. Please make sure that you have a valid wifi connection.",
                            context: context)
                        .getFlushbar()
                        .show(context);
                  }).then((token) {
                    CustomFlushbarSuccess(
                            title: "All tokens successfully blocked",
                            body:
                                "All your tokes were successfully blocked. You will be logged out since you don't have a valid token anymore.",
                            context: context)
                        .getFlushbar()
                          ..show(Navigator.of(context, rootNavigator: true)
                              .context);
                    return token;
                  });
              },
            ),
          ],
        ),
      );
}
