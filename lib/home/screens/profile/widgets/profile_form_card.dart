import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hqs_desktop/constants/constants.dart';
import 'package:hqs_desktop/generated/hqs-user-service/proto/hqs-user-service.pb.dart';
import 'package:hqs_desktop/home/screens/profile/constants/constants.dart';
import 'package:hqs_desktop/home/screens/profile/constants/text.dart';
import 'package:hqs_desktop/service/hqs_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:hqs_desktop/home/widgets/custom_text_form_field.dart';
import 'package:flushbar/flushbar.dart';
// import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

class ProfileFormCard extends StatefulWidget {
  final HqsService service;
  final Function onUpdate;

  ProfileFormCard({
    @required this.service,
    @required this.onUpdate,
  })  : assert(service != null),
        assert(onUpdate != null);
  @override
  _ProfileFormCardState createState() => _ProfileFormCardState(
        service: service,
        onUpdate: onUpdate,
      );
}

class _ProfileFormCardState extends State<ProfileFormCard> {
  // form controllers
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _phoneController = TextEditingController();
  final _titleController = TextEditingController();
  String countryCode = "";
  String dialCode = "";
  DateTime birthDate;
  String birthDateString = "";
  // constructor parameters
  final HqsService service;
  User user;
  final Function onUpdate;

  // init gender list
  bool _selectedGender = male;
  List<DropdownMenuItem<bool>> genderList = [];

  void loadGenderList() {
    genderList = [];
    genderList.add(new DropdownMenuItem(
      child: new Text('Male'),
      value: male,
    ));
    genderList.add(new DropdownMenuItem(
      child: new Text('Female'),
      value: female,
    ));
  }

  _ProfileFormCardState({
    @required this.service,
    @required this.onUpdate,
  }) {
    assert(service != null);

    this.user = service.curUser;

    _nameController.text = user.name;
    _emailController.text = user.email;
    _descriptionController.text = user.description;
    _selectedGender = user.gender;
    _phoneController.text = user.phone;
    _titleController.text = user.title;
    countryCode = user.countryCode;
    dialCode = user.dialCode;
    birthDate = user.birthDate.toDateTime();
    birthDateString = DateFormat('yyyy-MM-dd').format(birthDate);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double screenSplitSize =
        size.width / (size.width > screenSplit ? windowSplit : 1) - railSize;
    loadGenderList();
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(top: size.width > screenSplit ? profileImageRadius / 2 : cardPadding),
          child: Card(
            elevation: 4,
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(cardBorderRadius),
              ),
            ),
            child: SingleChildScrollView(
              child: Container(
                width: screenSplitSize,
                child: Padding(
                  padding: EdgeInsets.all(40),
                  child: Column(
                    children: [
                      Align(
                        child: Text(
                          editProfileCardTitle,
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                        alignment: Alignment.topLeft,
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Flexible(
                                  child: CustomTextFormField(
                                    defaultBorderColor: Colors.grey[300],
                                    controller: _nameController,
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return editProfileCardNameFieldValidator;
                                      }
                                      return null;
                                    },
                                    icon: Icon(Icons.person_outline),
                                    hintText: editProfileCardNameFieldHint,
                                    labelText: editProfileCardNameFieldText,
                                    obscure: false,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(12),
                                ),
                                Flexible(
                                  child: CustomTextFormField(
                                    defaultBorderColor: Colors.grey[300],
                                    controller: _emailController,
                                    hintText: editProfileCardEmailFieldHint,
                                    labelText: editProfileCardEmailFieldText,
                                    obscure: false,
                                    icon: Icon(
                                      Icons.mail_outline_rounded,
                                    ),
                                    validator: (value) {
                                      var validEmail = RegExp(
                                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                          .hasMatch(value);
                                      if (!validEmail) {
                                        return editProfileCardEmailFieldValidator;
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 26,
                            ),
                            Row(
                              children: <Widget>[
                                Flexible(
                                  child: DropdownButtonFormField(
                                    decoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: kPrimaryColor, width: 1.0),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.grey[300],
                                            width: 1.0),
                                      ),
                                    ),
                                    hint: new Text('Select Gender'),
                                    items: genderList,
                                    value: _selectedGender,
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedGender = value;
                                      });
                                    },
                                    isExpanded: true,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 18, right: 18),
                                ),
                                Flexible(
                                  child: Row(
                                    children: <Widget>[
                                      CountryCodePicker(
                                        onChanged: (country) {
                                          countryCode = country.code;
                                          dialCode = country.dialCode;
                                        },
                                        initialSelection: user.dialCode.isEmpty
                                            ? "US"
                                            : user.dialCode,
                                        showCountryOnly: false,
                                        showOnlyCountryWhenClosed: false,
                                        alignLeft: false,
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.only(right: 6, left: 6),
                                      ),
                                      Flexible(
                                        child: TextFormField(
                                          controller: _phoneController,
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ],
                                          keyboardType: TextInputType.phone,
                                          decoration: InputDecoration(
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: kPrimaryColor,
                                                  width: 1.0),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey[300],
                                                  width: 1.0),
                                            ),
                                            hintText: editProfileCardPhoneFieldHint,
                                            labelText: editProfileCardPhoneFieldText,
                                            suffixIcon: Icon(
                                              Icons.phone_android_outlined,
                                            ),
                                          ),
                                          validator: (value) {
                                            var validPhone =
                                                RegExp(r"^(?:[0]9)?[0-9]*")
                                                    .hasMatch(value);
                                            if (!validPhone) {
                                              return editProfileCardPhoneFieldValidator;
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 26,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Flexible(
                                  child: CustomTextFormField(
                                    defaultBorderColor: Colors.grey[300],
                                    controller: _titleController,
                                    validator: (value) {
                                      return null;
                                    },
                                    icon: Icon(Icons.badge),
                                    hintText: "Title",
                                    labelText: "Title",
                                    obscure: false,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(12),
                                ),
                                Flexible(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(
                                          cardBorderRadius),
                                    ),
                                    width: 500,
                                    height: 50,
                                    child: TextButton(
                                      child: Text(
                                        birthDateString,
                                      ),
                                      onPressed: () {
                                        DatePicker.showDatePicker(context,
                                            showTitleActions: true,
                                            onConfirm: (date) {
                                          setState(() {
                                            birthDate = date;
                                            birthDateString =
                                                DateFormat('yyyy-MM-dd')
                                                    .format(date);
                                          });
                                        },
                                            currentTime: DateTime(
                                              birthDate.year,
                                              birthDate.month,
                                              birthDate.day,
                                            ));
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 26,
                            ),
                            TextFormField(
                              keyboardType: TextInputType.multiline,
                              controller: _descriptionController,
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: kPrimaryColor, width: 1.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.grey[300], width: 1.0),
                                ),
                                hintText: 'Description',
                                labelText: 'Description',
                                suffixIcon: Icon(
                                  Icons.description,
                                ),
                              ),
                              minLines: 3,
                              maxLength: 500,
                              maxLines: 3,
                            ),
                            Padding(
                              padding: EdgeInsets.all(60),
                            ),
                            Align(
                                alignment: Alignment.bottomRight,
                                child: SizedBox(
                                    width: 200,
                                    height: 50.0,
                                    child: RaisedButton(
                                      color: kPrimaryColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            buttonBorderRadius),
                                      ),
                                      textColor: Colors.white,
                                      onPressed: () async => {
                                        if (_formKey.currentState.validate())
                                          {
                                            service
                                                .updateCurrentUser(
                                              context,
                                              _nameController.text,
                                              _emailController.text,
                                              _phoneController.text,
                                              countryCode,
                                              dialCode,
                                              _titleController.text,
                                              _selectedGender,
                                              _descriptionController.text,
                                              birthDate,
                                            )
                                                .catchError((error) {
                                              Flushbar(
                                                title: "Something went wrong",
                                                maxWidth: 800,
                                                icon: Icon(
                                                  Icons.error_outline,
                                                  size: 28.0,
                                                  color: Colors.red[600],
                                                ),
                                                flushbarPosition:
                                                    FlushbarPosition.TOP,
                                                message:
                                                    "We could not update your profile information. Please make sure you have a valid wifi connection.",
                                                margin: EdgeInsets.all(8),
                                                borderRadius: 8,
                                                duration: Duration(seconds: 5),
                                              )..show(context);
                                            }).then((value) {
                                              if (value != null) {
                                                onUpdate();
                                                Flushbar(
                                                  maxWidth: 800,
                                                  title:
                                                      "Successfully updated your profile",
                                                  icon: Icon(
                                                    Icons.info_outline,
                                                    size: 28.0,
                                                    color: Colors.green[500],
                                                  ),
                                                  flushbarPosition:
                                                      FlushbarPosition.TOP,
                                                  message:
                                                      "Your profile was successfully updated.",
                                                  margin: EdgeInsets.all(8),
                                                  borderRadius: 8,
                                                  duration:
                                                      Duration(seconds: 5),
                                                )..show(context);
                                              }
                                            })
                                          }
                                      },
                                      child: Text("Update Profile"),
                                    ))),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(12),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
