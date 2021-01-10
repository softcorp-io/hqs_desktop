import 'package:flutter/material.dart';
import 'package:dart_hqs/hqs_user_service.pb.dart';
import 'package:hqs_desktop/constants/constants.dart';
import 'package:hqs_desktop/home/screens/profile/widgets/profile_card.dart';
import 'package:hqs_desktop/service/hqs_user_service.dart';
import 'package:hqs_desktop/theme/theme.dart';

class ViewUserDialog extends StatelessWidget {
  final HqsService service;
  final User user;
  final HqsTheme theme;
  final BuildContext buildContext;

  ViewUserDialog(
      {@required this.service,
      @required this.theme,
      @required this.user,
      @required this.buildContext})
      : assert(service != null),
        assert(buildContext != null),
        assert(user != null);

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(cardBorderRadius),
        ),
        backgroundColor: Colors.transparent,
        child: SingleChildScrollView(
            child: ProfileCard(
                theme: theme,
                onClose: () {
                  Navigator.of(buildContext, rootNavigator: true).pop();
                },
                dialogSize: 700.0,
                showCloseButton: true,
                service: service,
                onImageUpdate: () {},
                showEditImage: false,
                user: user)));
  }
}
