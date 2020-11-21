import 'package:flutter/material.dart';
import 'package:hqs_desktop/screens/home/screens/profile/widgets/profile_card.dart';
import 'package:hqs_desktop/screens/home/screens/profile/widgets/profile_form_card.dart';
import 'package:hqs_desktop/service/hqs_service.dart';
import 'package:hqs_desktop/generated/hqs-user-service/proto/hqs-user-service.pb.dart';

class ProfileInfo extends StatefulWidget {
  final HqsService service;

  ProfileInfo({@required this.service}) : assert(service != null);

  @override
  _ProfileInfoState createState() => _ProfileInfoState(service: service);
}

class _ProfileInfoState extends State<ProfileInfo> {
  HqsService service;
  User user;

  final double profileImageRadius = 120.0;

  Future<Response> userResponse;
  _ProfileInfoState({@required this.service}) {
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
    return Container(
        color: Colors.grey[100],
        child: Column(
          children: <Widget>[
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
          ],
        ));
  }
}
