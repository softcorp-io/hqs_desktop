import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:hqs_desktop/constants/constants.dart';
import 'package:hqs_desktop/generated/hqs-user-service/proto/hqs-user-service.pb.dart';
import 'package:hqs_desktop/screens/home/screens/profile/utils/auth_source.dart';
import 'package:hqs_desktop/service/hqs_service.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileAuthHistory extends StatefulWidget {
  final HqsService service;
  final double profileImageRadius;

  ProfileAuthHistory(
      {@required this.service, @required this.profileImageRadius})
      : assert(service != null),
        assert(profileImageRadius != null);

  @override
  _ProfileAuthHistoryState createState() => _ProfileAuthHistoryState(
      service: service, profileImageRadius: profileImageRadius);
}

class _ProfileAuthHistoryState extends State<ProfileAuthHistory> {
  // constructor parameters
  final HqsService service;
  final double profileImageRadius;
  Future<AuthHistory> authHistoryResponse;
  AuthHistory authHistory;

  _ProfileAuthHistoryState(
      {@required this.service, @required this.profileImageRadius}) {
    assert(service != null);
    assert(profileImageRadius != null);
    this.authHistoryResponse =
        service.getCurrentUserAuthHistory().then((authHistory) {
      this.authHistory = authHistory;
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
                      padding: EdgeInsets.only(top: 120),
                      child: Align(
                          child: Container(
                            child: CircularProgressIndicator(),
                          ),
                          alignment: Alignment.center));
                case ConnectionState.done:
                  final authSource = AuthHistorySource(
                    onRowSelect: (index) => _blockTokenDetails(
                        context, authHistory.authHistory[index]),
                    authData: authHistory.authHistory,
                  );
                  return Container(
                      width: size.width,
                      height: 650,
                      child: Padding(
                          padding: EdgeInsets.all(16),
                          child: PaginatedDataTable(
                            actions: [
                              SizedBox(
                                  width: 130,
                                  height: 35.0,
                                  child: RaisedButton(
                                    onPressed: () {
                                      _blockAllTokensDetails(context);
                                    },
                                    color: Colors.red[800],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          cardBorderRadius),
                                    ),
                                    child: Text("Block all tokens"),
                                    textColor: Colors.white,
                                  )),
                            ],
                            headingRowHeight: 80,
                            dataRowHeight: 80,
                            rowsPerPage: 5,
                            source: authSource,
                            header: Text(
                              "Login History",
                              style: GoogleFonts.poppins(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                            columns: _colGen(authSource),
                          )));
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
          label: Text("Location"),
        ),
        DataColumn(
          label: Text("Status"),
        ),
        DataColumn(
          label: Text("Last Used At"),
        ),
        DataColumn(
          label: Text("Created At"),
        ),
        DataColumn(
          label: Text("Expires At"),
        ),
        DataColumn(
          label: Text("Actions"),
        ),
      ];

  void _blockTokenDetails(BuildContext c, Auth auth) async =>
      await showDialog<bool>(
        context: c,
        builder: (_) => AlertDialog(
          title: Text(
            "Block Token?",
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
                  "You are about to block a token. If you suspect that someone",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                  ),
                ),
                Text(
                  "has misused your account, you should change your password",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                  ),
                ),
                Text(
                  "and use the block all tokens functionality above.",
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
                Navigator.of(context, rootNavigator: true).pop();
              },
            ),
            TextButton(
              child: Text(
                "Block",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: kPrimaryColor,
                ),
              ),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
                service.blockTokenByID(auth.tokenID)
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
                          "We could not block the specified token. Please make sure that you have a valid wifi connection.",
                      margin: EdgeInsets.all(8),
                      borderRadius: 8,
                      duration: Duration(seconds: 5),
                    )..show(context);
                  }).then((token) {
                    Flushbar(
                      title: "Token successfully blocked",
                      maxWidth: 800,
                      icon: Icon(
                        Icons.check_circle,
                        size: 28.0,
                        color: Colors.green,
                      ),
                      flushbarPosition: FlushbarPosition.TOP,
                      message:
                          "The token was succesfully blocked and no one can use it to log into your account anymore.",
                      margin: EdgeInsets.all(8),
                      borderRadius: 8,
                      duration: Duration(seconds: 5),
                    )..show(context);
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
              color: Colors.black,
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
                    color: Colors.black,
                  ),
                ),
                Text(
                  "has misused your account, you should change your password as well.",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                  ),
                ),
                Text(
                  "After blocking all tokens, you will be logged out since you don't",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                  ),
                ),
                Text(
                  "have a valid token anymore.",
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
                Navigator.of(context, rootNavigator: true).pop();
              },
            ),
            TextButton(
              child: Text(
                "Block All",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: kPrimaryColor,
                ),
              ),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
                service.blockAllUsersTokens()
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
                          "We could not block all tokens. Please make sure that you have a valid wifi connection.",
                      margin: EdgeInsets.all(8),
                      borderRadius: 8,
                      duration: Duration(seconds: 5),
                    )..show(context);
                  }).then((token) {
                    Flushbar(
                      title: "All tokens successfully blocked",
                      maxWidth: 800,
                      icon: Icon(
                        Icons.check_circle,
                        size: 28.0,
                        color: Colors.green,
                      ),
                      flushbarPosition: FlushbarPosition.TOP,
                      message:
                          "All your tokes were successfully blocked. You will be logged out since you don't have a valid token anymore.",
                      margin: EdgeInsets.all(8),
                      borderRadius: 8,
                      duration: Duration(seconds: 5),
                    )..show(Navigator.of(context, rootNavigator: true).context);
                    return token;
                  });
              },
            ),
          ],
        ),
      );
}
