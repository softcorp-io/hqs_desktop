import 'package:flutter/material.dart';
import 'package:hqs_desktop/screens/home/screens/profile/constants/constants.dart';
import 'package:hqs_desktop/screens/home/screens/profile/widgets/profile_card.dart';
import 'package:hqs_desktop/screens/home/screens/profile/widgets/profile_form_card.dart';
import 'package:hqs_desktop/screens/home/screens/profile/widgets/profile_auth_history.dart';
import 'package:hqs_desktop/screens/home/widgets/custom_navigationrail.dart';
import 'package:hqs_desktop/service/hqs_service.dart';
import 'package:hqs_desktop/generated/hqs-user-service/proto/hqs-user-service.pb.dart';
import 'package:hqs_desktop/screens/home/screens/profile/widgets/profile_password_form.dart';

class ProfilePage extends StatefulWidget {
  final HqsService service;

  ProfilePage({@required this.service}) : assert(service != null);

  @override
  _ProfilePageState createState() => _ProfilePageState(service: service);
}

class _ProfilePageState extends State<ProfilePage> {
  final HqsService service;
  User user;
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
    Size size = MediaQuery.of(context).size;
    EdgeInsets edgeInsets = EdgeInsets.all(cardPadding);
    return CustomNavigationrail(
        title: "Profile",
        service: service,
        body: SingleChildScrollView(
          child: Padding(
            padding: edgeInsets,
            child: Column(
              children: <Widget>[
                SizedBox(height: 20),
                // Profile card and form information
                Wrap(
                    alignment: WrapAlignment.center,
                    direction: Axis.horizontal,
                    textDirection: TextDirection.rtl,
                    children: <Widget>[
                      ProfileCard(
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
                        service: service,
                      ),
                      SizedBox(width: cardPadding),
                      ProfileFormCard(
                        onUpdate: () {
                          reload();
                        },
                        service: service,
                      ),
                    ]),
                SizedBox(height: 16),
                // Password card and form information
                ProfilePasswordForm(
                  service: service,
                ),
                // Users auth history
                SizedBox(height: 16),
                SingleChildScrollView(
                  child: Container(
                    color: Colors.grey[100],
                    child: ProfileAuthHistory(
                      service: service,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
