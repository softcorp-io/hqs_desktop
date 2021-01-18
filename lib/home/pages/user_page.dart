import 'package:flutter/material.dart';
import 'package:hqs_desktop/home/screens/profile/constants/constants.dart';
import 'package:hqs_desktop/home/screens/profile/widgets/profile_card.dart';
import 'package:hqs_desktop/home/widgets/home_appbar.dart';
import 'package:hqs_desktop/service/hqs_service.dart';
import 'package:dart_hqs/hqs_user_service.pb.dart';

class UserPage extends StatefulWidget {
  final HqsService service;
  final Function navigateToProfile;
  final User user;
  UserPage(
      {@required this.service,
      @required this.user,
      @required this.navigateToProfile})
      : assert(service != null),
        assert(navigateToProfile != null),
        assert(user != null);
  @override
  _UserPageState createState() {
    return _UserPageState(
        service: service, user: user, navigateToProfile: navigateToProfile);
  }
}

class _UserPageState extends State<UserPage> {
  final HqsService service;
  final Function navigateToProfile;
  final User user;
  _UserPageState(
      {@required this.service,
      @required this.user,
      @required this.navigateToProfile})
      : assert(service != null),
        assert(navigateToProfile != null),
        assert(user != null);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    EdgeInsets edgeInsets = EdgeInsets.all(cardPadding);
    return Scaffold(
      appBar: HomeAppBar(
        popContext: () {
          Navigator.pop(context);
        },
        navigateToProfile: () {
          Navigator.pop(context);
          navigateToProfile();
        },
        shadow: true,
        service: service,
        user: service.curUser,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: edgeInsets,
          child: ProfileCard(
              cardSize: size.width,
              constraintSize: false,
              service: service,
              onImageUpdate: () {},
              showEditImage: false,
              user: user),
        ),
      ),
    );
  }
}
