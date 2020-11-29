import 'package:flutter/material.dart';
import 'package:hqs_desktop/screens/home/screens/profile/widgets/profile_card.dart';
import 'package:hqs_desktop/screens/home/screens/profile/widgets/profile_form_card.dart';
import 'package:hqs_desktop/screens/home/screens/profile/widgets/profile_auth_history.dart';
import 'package:hqs_desktop/screens/home/widgets/drawer.dart';
import 'package:hqs_desktop/screens/home/widgets/home_appbar.dart';
import 'package:hqs_desktop/service/hqs_service.dart';
import 'package:hqs_desktop/generated/hqs-user-service/proto/hqs-user-service.pb.dart';
import 'package:hqs_desktop/constants/constants.dart';
import 'package:hqs_desktop/screens/home/screens/profile/widgets/profile_password_card.dart';

class ProfilePage extends StatefulWidget {
  final HqsService service;

  ProfilePage({@required this.service}) : assert(service != null);

  @override
  _ProfilePageState createState() => _ProfilePageState(service: service);
}

class _ProfilePageState extends State<ProfilePage> {
  HqsService service;
  User user;

  final double profileImageRadius = 120.0;

  Future<Response> userResponse;
  _ProfilePageState({@required this.service}) {
    this.userResponse = service.getCurrentUser().then((value) {
      if (value.user.id != "") {
        this.user = value.user;
      }
      return value;
    });
  }

  reload() {
    this.userResponse = service.getCurrentUser().then((value) {
      if (value.user.id != "") {
        this.user = value.user;
      }
      return value;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      drawer: HomeDrawer(
        service: service,
      ),
      appBar: HomeAppBar(title: "Profile", shadow: true, service: service,),
      body: FutureBuilder<Response>(
          future: userResponse,
          builder: (BuildContext context, AsyncSnapshot<Response> snapshot) {
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
                return Container(
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
                                        setState(() {
                                          reload();
                                        });
                                      },
                                      service: service,
                                      user: user,
                                      profileImageRadius: profileImageRadius,
                                    ),
                                  ),
                                ),
                                Flexible(
                                  child: Padding(
                                    padding: EdgeInsets.all(16),
                                    child: ProfileCard(
                                      profileImageRadius: profileImageRadius,
                                      service: service,
                                      user: user,
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
                    ));
            }
          }),
    );
  }
}
