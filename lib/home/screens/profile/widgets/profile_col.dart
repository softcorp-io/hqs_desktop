import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hqs_desktop/home/screens/profile/constants/constants.dart';
import 'package:hqs_desktop/home/screens/profile/widgets/profile_card.dart';
import 'package:hqs_desktop/home/screens/profile/widgets/profile_form_card.dart';
import 'package:hqs_desktop/service/hqs_service.dart';
import 'package:dart_hqs/hqs_user_service.pb.dart';
import 'package:intl/intl.dart' as format;
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class ProfileCol extends StatefulWidget {
  final HqsService service;
  final Function onUpdate;
  ProfileCol({
    @required this.service,
    @required this.onUpdate,
  })  : assert(service != null),
        assert(onUpdate != null);
  @override
  _ProfileColState createState() {
    return _ProfileColState(service: service, onUpdate: onUpdate);
  }
}

class _ProfileColState extends State<ProfileCol> {
  final HqsService service;
  User user;
  DateTime birthday;
  String birthdayString;
  final Function onUpdate;

  _ProfileColState({
    @required this.service,
    @required this.onUpdate,
  })  : assert(service != null),
        assert(onUpdate != null) {
    user = service.curUser;
    try {
      birthday = new format.DateFormat("yyyy-MM-dd").parse(user.birthday);
      birthdayString = new format.DateFormat("yyyy-MM-dd").format(birthday);
    } catch (e) {
      birthday = new DateTime.now();
      birthdayString = new format.DateFormat("yyyy-MM-dd").format(birthday);
    }
  }

  void setBirthday(DateRangePickerSelectionChangedArgs args) {
    SchedulerBinding.instance.addPostFrameCallback((duration) {
      setState(() {
        birthday = args.value;
        birthdayString = format.DateFormat('yyyy-MM-dd').format(args.value);
      });
    });
  }

  void setGender(bool value) {
    setState(() {
      user.gender = value;
    });
  }

  void setCountry(CountryCode country) {
    user.countryCode = country.code;
    user.dialCode = country.dialCode;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
        alignment: WrapAlignment.center,
        direction: Axis.horizontal,
        textDirection: TextDirection.rtl,
        children: <Widget>[
          ProfileCard(
            user: user,
            constraintSize: true,
            showEditImage: true,
            cardSize: 0.0,
            onImageUpdate: () {
              onUpdate();
              setState(() {
                user = service.curUser;
              });
            },
            service: service,
          ),
          SizedBox(width: cardPadding),
          ProfileFormCard(
            birthday: birthday,
            setCountry: setCountry,
            setBirthday: setBirthday,
            setGender: setGender,
            user: user,
            birthdayString: birthdayString,
            onUpdate: () {
              onUpdate();
              setState(() {
                user = service.curUser;
              });
            },
            service: service,
          ),
        ]);
  }
}
