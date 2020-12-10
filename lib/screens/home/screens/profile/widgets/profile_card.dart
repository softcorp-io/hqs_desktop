import 'package:flutter/material.dart';
import 'package:hqs_desktop/constants/constants.dart';
import 'package:hqs_desktop/generated/hqs-user-service/proto/hqs-user-service.pb.dart';
import 'package:hqs_desktop/screens/home/screens/profile/constants/constants.dart';
import 'package:hqs_desktop/service/hqs_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flushbar/flushbar.dart';

class ProfileCard extends StatelessWidget {
  final HqsService service;
  final Function onUpdate;
  final User user;

  ProfileCard(
      {@required this.service,
      @required this.user,
      @required this.onUpdate})
      : assert(service != null),
        assert(user != null),
        assert(onUpdate != null);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double screenSplitSize =
        size.width / (size.width > screenSplit ? windowSplit : 1) -
            railSize;
    return Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(
            top: profileImageRadius / 2.0,
          ),

          //here we create space for the circle avatar to get ut of the box
          child: Card(
            clipBehavior: Clip.antiAlias,
            color: kBlueOne,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(cardBorderRadius),
              ),
            ),
            elevation: 4,
            child: Container(
              width: screenSplitSize,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [kBlueOne, kBlueTwoHalf],
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight),
              ),
              child: Padding(
                  padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: Column(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: EdgeInsets.only(right: 16),
                          child: Container(
                            width: 55,
                            height: 35,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(cardBorderRadius),
                                color: Colors.white),
                            child: Align(
                              child: Text(
                                "Profile",
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[900],
                                ),
                              ),
                              alignment: Alignment.center,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: profileImageRadius / 2,
                      ),
                      Text(
                        user.name,
                        style: GoogleFonts.poppins(
                          fontSize: 26,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        user.title.isEmpty ? "No title specified" : user.title,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.amber[300],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(18),
                        child: Text(
                          user.description.isEmpty
                              ? "No decription added yet."
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
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 12),
                                SelectableText(
                                  user.email,
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
                                      ? "Not specified"
                                      : user.dialCode + " " + user.phone,
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
                                  DateFormat('yyyy-MM-dd')
                                      .format(user.birthDate.toDateTime()),
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
          ),
        ),

        ///Image Avatar
        Container(
          width: profileImageRadius,
          height: profileImageRadius,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.transparent,
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
                backgroundColor: Colors.grey[100]),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                width: 33,
                height: 33,
                child: IconButton(
                  onPressed: () {
                    service.uploadUserImage().then((value) {
                      if (value != null) {
                        Flushbar(
                          maxWidth: 800,
                          title: "Successfully uploaded your image",
                          icon: Icon(
                            Icons.info_outline,
                            size: 28.0,
                            color: Colors.green[500],
                          ),
                          flushbarPosition: FlushbarPosition.TOP,
                          message:
                              "Your profile image was successfully updated.",
                          margin: EdgeInsets.all(8),
                          borderRadius: 8,
                          duration: Duration(seconds: 5),
                        )..show(context);
                        onUpdate();
                      }
                    });
                  },
                  icon: Icon(
                    Icons.edit,
                    color: kPrimaryColor,
                    size: 19,
                  ),
                ),
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: Colors.white),
              ),
            ),
          ]),
        ),
      ],
    );
  }
}

class LinearGradientMask extends StatelessWidget {
  LinearGradientMask({this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) {
        return RadialGradient(
          center: Alignment.topLeft,
          radius: 1,
          colors: [kBlueOne, kBlueTwo, kBlueThree],
          tileMode: TileMode.mirror,
        ).createShader(bounds);
      },
      child: child,
    );
  }
}
