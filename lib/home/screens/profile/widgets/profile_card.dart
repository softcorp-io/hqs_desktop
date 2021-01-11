import 'package:flutter/material.dart';
import 'package:hqs_desktop/constants/constants.dart';
import 'package:dart_hqs/hqs_user_service.pb.dart';
import 'package:hqs_desktop/home/screens/profile/constants/constants.dart';
import 'package:hqs_desktop/home/screens/profile/constants/text.dart';
import 'package:hqs_desktop/home/widgets/custom_flushbar_error.dart';
import 'package:hqs_desktop/home/widgets/custom_flushbar_success.dart';
import 'package:hqs_desktop/service/hqs_user_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hqs_desktop/theme/constants.dart';
import 'package:intl/intl.dart';

class ProfileCard extends StatelessWidget {
  final User user;
  final Function onImageUpdate;
  final HqsService service;
  final bool showEditImage;
  final bool constraintSize;
  final double cardSize;
  ProfileCard(
      {@required this.service,
      @required this.constraintSize,
      @required this.onImageUpdate,
      @required this.showEditImage,
      @required this.cardSize,
      @required this.user})
      : assert(service != null),
        assert(user != null),
        assert(cardSize != null),
        assert(showEditImage != null),
        assert(onImageUpdate != null);

  String getUserBirthday(User user) {
    DateTime birthday;
    String birthdayString;
    try {
      birthday = new DateFormat("yyyy-MM-dd").parse(user.birthday);
      birthdayString = new DateFormat("yyyy-MM-dd").format(birthday);
    } catch (e) {
      birthday = new DateTime.now();
      birthdayString = new DateFormat("yyyy-MM-dd").format(birthday);
    }
    return birthdayString;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double screenSplitSize =
        size.width / (size.width > screenSplit ? windowSplit : 1) - railSize;
    return Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        //here we create space for the circle avatar to get ut of the box
        Card(
          color: Colors.transparent,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(cardBorderRadius),
            ),
          ),
          elevation: 4,
          child: Container(
              width: constraintSize ? screenSplitSize : cardSize,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: defaultGradientColor,
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight),
              ),
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: EdgeInsets.all(15),
                      child: Container(
                        width: 60,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(cardBorderRadius),
                        ),
                        child: Card(
                          child: Align(
                            child: Text(
                              profileCardTitle,
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            alignment: Alignment.center,
                          ),
                        ),
                      ),
                    ),
                  ),

                  ///Image Avatar
                  Container(
                    width: profileImageRadius,
                    height: profileImageRadius,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black38,
                          blurRadius: 6.0,
                          offset: Offset(0.0, 3.0),
                        ),
                      ],
                    ),
                    child: Stack(children: [
                      CircleAvatar(
                          radius: profileImageRadius,
                          backgroundImage: NetworkImage(user.image),
                          backgroundColor: Colors.transparent),
                      showEditImage
                          ? Align(
                              alignment: Alignment.bottomRight,
                              child: Container(
                                width: 33,
                                height: 33,
                                child: IconButton(
                                  onPressed: () {
                                    service.uploadUserImage(
                                        _showImageWaitingDialog, () {
                                      Navigator.of(context, rootNavigator: true)
                                          .pop();
                                    }, context).catchError((error) {
                                      CustomFlushbarError(
                                              title: uploadPhoneExceptionTitle,
                                              body: uploadPhoneExceptionText)
                                          .getFlushbar()
                                          .show(context);
                                    }).then((value) {
                                      if (value != null) {
                                        onImageUpdate();
                                        CustomFlushbarSuccess(
                                          title: uploadPhoneSuccessTitle,
                                          body: uploadPhoneSuccessText,
                                        ).getFlushbar()
                                          ..show(context);
                                      }
                                    });
                                  },
                                  icon: Icon(
                                    Icons.edit,
                                    size: 19,
                                  ),
                                ),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                ),
                              ),
                            )
                          : Container(),
                    ]),
                  ),
                  SelectableText(
                    user.name,
                    style: GoogleFonts.poppins(
                      fontSize: 26,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  SelectableText(
                    user.title.isEmpty ? titleNotSpecifiedText : user.title,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.amber[500],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(18),
                    child: SelectableText(
                      user.description.isEmpty
                          ? descriptionNotSpecifiedText
                          : user.description,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.white70,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Wrap(
                      alignment: WrapAlignment.spaceEvenly,
                      direction: Axis.horizontal,
                      runSpacing: 20,
                      spacing: 75,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Container(
                              height: 60,
                              width: 60,
                              child: CircleAvatar(
                                child: Container(
                                  width: 60,
                                  height: 60,
                                  child: LinearGradientMask(
                                      child: Icon(
                                    Icons.email,
                                    size: 35,
                                  )),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 12),
                            SelectableText(
                              user.email,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.white,
                                  fontFamily: ''),
                            ),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Container(
                              height: 60,
                              width: 60,
                              child: CircleAvatar(
                                child: Container(
                                  width: 60,
                                  height: 60,
                                  child: LinearGradientMask(
                                      child: Icon(
                                    Icons.phone_android,
                                    size: 35,
                                  )),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                            SizedBox(height: 12),
                            SelectableText(
                              user.phone.isEmpty
                                  ? phoneNotSpecifiedText
                                  : user.dialCode + " " + user.phone,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.white,
                                  fontFamily: ''),
                            ),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Container(
                              height: 60,
                              width: 60,
                              child: CircleAvatar(
                                child: Container(
                                  width: 60,
                                  height: 60,
                                  child: LinearGradientMask(
                                      child: Icon(
                                    Icons.date_range,
                                    size: 35,
                                  )),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                            SizedBox(height: 12),
                            SelectableText(
                              getUserBirthday(user),
                              style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.white,
                                  fontFamily: ''),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 100.0,
                  ),
                ],
              )),
        ),
      ],
    );
  }

  void _showImageWaitingDialog(BuildContext c) async => await showDialog<bool>(
        context: c,
        builder: (_) => Container(
          width: 800,
          height: 1000,
          child: AlertDialog(
            title: Text(
              waitingUploadDialogTitle,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Container(
                    child: CircularProgressIndicator(),
                    alignment: Alignment.center,
                    width: 50,
                    height: 50,
                  ),
                  SizedBox(
                    height: 18,
                  ),
                  Text(
                    waitingUploadDialogText,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}

class LinearGradientMask extends StatelessWidget {
  final Widget child;
  LinearGradientMask({this.child});
  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) {
        return RadialGradient(
          center: Alignment.topLeft,
          radius: 1,
          colors: defaultGradientColor,
          tileMode: TileMode.mirror,
        ).createShader(bounds);
      },
      child: child,
    );
  }
}
