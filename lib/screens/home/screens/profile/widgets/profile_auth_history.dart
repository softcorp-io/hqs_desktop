import 'package:flutter/material.dart';
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
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 120 / 2),
          child: Padding(
            padding: EdgeInsets.all(40),
            child: Column(children: [
              FutureBuilder<AuthHistory>(
                  future: authHistoryResponse,
                  builder: (BuildContext context,
                      AsyncSnapshot<AuthHistory> snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.active:
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                        return Align(
                            child: Container(
                              child: CircularProgressIndicator(),
                            ),
                            alignment: Alignment.center);
                      case ConnectionState.done:
                        final authSource = AuthHistorySource(
                          authData: authHistory.authHistory,
                        );
                        return PaginatedDataTable(
                          source: authSource,
                          header: Text(
                            "Authentication History",
                            style: GoogleFonts.poppins(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                          columns: _colGen(authSource),
                        );
                    }
                    ;
                  })
            ]),
          ),
        ),
      ],
    );
  }

  List<DataColumn> _colGen(
    AuthHistorySource _src,
    //UserDataNotifier _provider,
  ) =>
      <DataColumn>[
        DataColumn(
          label: Text("Expires At"),
        ),
        DataColumn(
          label: Text("Created At"),
        ),
        DataColumn(
          label: Text("Longitude"),
        ),
        DataColumn(
          label: Text("Latitude"),
        ),
        DataColumn(
          label: Text("Token ID"),
        ),
      ];
}
