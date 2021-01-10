import 'package:flutter/material.dart';
import 'package:hqs_desktop/home/screens/profile/constants/constants.dart';
import 'package:hqs_desktop/home/screens/profile/widgets/profile_col.dart';
import 'package:hqs_desktop/home/screens/profile/widgets/profile_auth_history.dart';
import 'package:hqs_desktop/service/hqs_user_service.dart';
import 'package:dart_hqs/hqs_user_service.pb.dart';
import 'package:hqs_desktop/home/screens/profile/widgets/profile_password_form.dart';

class ProfilePage extends StatefulWidget {
  final HqsService service;
  ProfilePage({@required this.service}) : assert(service != null);
  @override
  _ProfilePageState createState() {
    return _ProfilePageState(service: service);
  }
}

class _ProfilePageState extends State<ProfilePage> {
  final HqsService service;
  User user;
  Future<Response> userResponse;

  _ProfilePageState({@required this.service}) : assert(service != null) {
    userResponse = service.getCurrentUser().then((value) {
      user = value.user;
      return value;
    });
  }

  @override
  Widget build(BuildContext context) {
    EdgeInsets edgeInsets = EdgeInsets.all(cardPadding);
    return FutureBuilder<Response>(
        future: userResponse,
        builder: (BuildContext context, AsyncSnapshot<Response> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return SingleChildScrollView(
                child: Padding(
                  padding: edgeInsets,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 20),
                      // Profile card and form information
                      ProfileCol(
                        service: service,
                        onImageUpdate: () {
                          setState(() {});
                        },
                      ),
                      SizedBox(height: 16),
                      // Password card and form information
                      ProfilePasswordForm(
                        service: service,
                      ),
                      // Users auth history
                      SizedBox(height: 16),
                      SingleChildScrollView(
                        child: Container(
                          color: Colors.transparent,
                          child: ProfileAuthHistory(
                            service: service,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            default:
              return Align(
                  child: Container(
                    child: CircularProgressIndicator(),
                  ),
                  alignment: Alignment.center);
          }
        });
  }
}
