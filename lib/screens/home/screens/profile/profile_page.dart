import 'package:flutter/material.dart';
import 'package:hqs_desktop/screens/home/screens/profile/widgets/profile_card.dart';
import 'package:hqs_desktop/screens/home/screens/profile/widgets/profile_form_card.dart';
import 'package:hqs_desktop/screens/home/screens/profile/widgets/profile_auth_history.dart';
import 'package:hqs_desktop/screens/home/widgets/drawer.dart';
import 'package:hqs_desktop/screens/home/widgets/home_appbar.dart';
import 'package:hqs_desktop/service/hqs_service.dart';
import 'package:hqs_desktop/generated/hqs-user-service/proto/hqs-user-service.pb.dart';
import 'package:hqs_desktop/screens/home/screens/profile/widgets/profile_password_card.dart';

class ProfilePage extends StatefulWidget {
  final HqsService service;

  ProfilePage({@required this.service}) : assert(service != null);

  @override
  _ProfilePageState createState() => _ProfilePageState(service: service);
}

class _ProfilePageState extends State<ProfilePage> {
  final HqsService service;
  User user;
  final double profileImageRadius = 135.0;

  Future<Response> userResponse;
  _ProfilePageState({@required this.service}) {
    this.user = service.curUser;
  }

  reload() {
    this.userResponse = service.getCurrentUser().then((value) {
      setState(() {
        user = value.user;
      });
      return value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: HomeDrawer(
        service: service,
      ),
      appBar: HomeAppBar(
        title: "Profile",
        shadow: true,
        service: service,
      ),
      body: Container(
          color: Colors.grey[100],
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                // Profile card and form information
                Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Flexible(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: ProfileFormCard(
                            onUpdate: () {
                              reload();
                            },
                            service: service,
                            profileImageRadius: profileImageRadius,
                          ),
                        ),
                      ),
                      Flexible(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: ProfileCard(
                            onUpdate: () {
                              this.userResponse =
                                  service.getCurrentUser().then((value) {
                                setState(() {
                                  user = value.user;
                                });
                                return value;
                              });
                            },
                            user: user,
                            profileImageRadius: profileImageRadius,
                            service: service,
                          ),
                        ),
                      ),
                    ]),
                // Password card and form information
                Padding(
                  padding: EdgeInsets.all(16),
                  child: ProfilePasswordCard(
                    service: service,
                    profileImageRadius: profileImageRadius,
                  ),
                ),
                // Users auth history
                SizedBox(height: 32),
                SingleChildScrollView(
                  child: Container(
                    color: Colors.grey[100],
                    child: ProfileAuthHistory(
                      service: service,
                      profileImageRadius: profileImageRadius,
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
