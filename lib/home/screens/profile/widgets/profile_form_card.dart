import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hqs_desktop/constants/constants.dart';
import 'package:dart_hqs/hqs_user_service.pb.dart';
import 'package:hqs_desktop/home/screens/profile/constants/constants.dart';
import 'package:hqs_desktop/home/screens/profile/constants/text.dart';
import 'package:hqs_desktop/home/widgets/custom_flushbar_error.dart';
import 'package:hqs_desktop/home/widgets/custom_flushbar_success.dart';
import 'package:hqs_desktop/service/hqs_user_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:hqs_desktop/home/widgets/custom_text_form_field.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class ProfileFormCard extends StatelessWidget {
  // form controllers
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _phoneController = TextEditingController();
  final _titleController = TextEditingController();

  // constructor parameters
  final HqsService service;
  final Function onUpdate;
  final User user;
  final DateTime birthday;
  final String birthdayString;
  final Function setBirthday;
  final Function setGender;
  final Function setCountry;

  // init gender list
  final List<DropdownMenuItem<bool>> genderList = [
    new DropdownMenuItem(
      child: new Text('Male'),
      value: male,
    ),
    new DropdownMenuItem(
      child: new Text('Female'),
      value: female,
    )
  ];

  ProfileFormCard({
    @required this.service,
    @required this.onUpdate,
    @required this.user,
    @required this.birthday,
    @required this.birthdayString,
    @required this.setBirthday,
    @required this.setCountry,
    @required this.setGender,
  }) {
    assert(service != null);
    assert(onUpdate != null);
    assert(user != null);
    assert(birthday != null);
    assert(setBirthday != null);
    assert(setGender != null);
    assert(setCountry != null);
    assert(birthdayString != null && birthdayString.isNotEmpty);
    _nameController.text = user.name;
    _emailController.text = user.email;
    _descriptionController.text = user.description;
    _phoneController.text = user.phone;
    _titleController.text = user.title;
  }

  double calendarHeight = 500;
  double calendarWidth = 500;
  Widget getDateRangePicker() {
    return Container(
        height: calendarHeight,
        width: calendarHeight,
        child: SfDateRangePicker(
          initialDisplayDate: birthday,
          initialSelectedDate: birthday,
          view: DateRangePickerView.month,
          selectionMode: DateRangePickerSelectionMode.single,
          onSelectionChanged: setBirthday,
        ));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double screenSplitSize =
        size.width / (size.width > screenSplit ? windowSplit : 1) - railSize;
    return Stack(
      children: [
        Card(
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
                                  keyboardType: TextInputType.name,
                                  maxLength: 50,
                                  minLines: 1,
                                  maxLines: 1,
                                  controller: _nameController,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return editProfileCardNameFieldValidator;
                                    }
                                    return null;
                                  },
                                  icon: Icons.person_outline,
                                  focusNode: FocusNode(),
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
                                  keyboardType: TextInputType.emailAddress,
                                  maxLength: 100,
                                  minLines: 1,
                                  maxLines: 1,
                                  controller: _emailController,
                                  hintText: editProfileCardEmailFieldHint,
                                  labelText: editProfileCardEmailFieldText,
                                  obscure: false,
                                  icon: Icons.mail_outline_rounded,
                                  focusNode: FocusNode(),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Flexible(
                                child: DropdownButtonFormField(
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Theme.of(context).primaryColor,
                                          width: 1.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Theme.of(context).hintColor,
                                          width: 1.0),
                                    ),
                                  ),
                                  hint: new Text('Select Gender'),
                                  items: genderList,
                                  value: user.gender,
                                  onChanged: (value) {
                                    setGender(value);
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
                                        setCountry(country);
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
                                      child: CustomTextFormField(
                                          controller: _phoneController,
                                          focusNode: FocusNode(),
                                          keyboardType: TextInputType.phone,
                                          validator: (value) {
                                            var validPhone =
                                                RegExp(r"^(?:[0]9)?[0-9]*")
                                                    .hasMatch(value);
                                            if (!validPhone) {
                                              return editProfileCardPhoneFieldValidator;
                                            }
                                            return null;
                                          },
                                          hintText:
                                              editProfileCardPhoneFieldHint,
                                          labelText:
                                              editProfileCardPhoneFieldText,
                                          maxLength: 40,
                                          minLines: 1,
                                          maxLines: 1,
                                          obscure: false),
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
                                  keyboardType: TextInputType.name,
                                  maxLength: 50,
                                  minLines: 1,
                                  maxLines: 1,
                                  controller: _titleController,
                                  validator: (value) {
                                    return null;
                                  },
                                  icon: Icons.badge,
                                  focusNode: FocusNode(),
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
                                    borderRadius:
                                        BorderRadius.circular(cardBorderRadius),
                                  ),
                                  width: 500,
                                  height: 50,
                                  child: TextButton(
                                    style: ButtonStyle(backgroundColor:
                                        MaterialStateColor.resolveWith(
                                            (states) {
                                      return Theme.of(context).dividerColor;
                                    })),
                                    child: Text(
                                      birthdayString,
                                    ),
                                    onPressed: () async {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                                title: Text('Pick a date'),
                                                content: Container(
                                                  height: calendarHeight + 50,
                                                  width: calendarHeight,
                                                  child: Column(
                                                    children: <Widget>[
                                                      getDateRangePicker(),
                                                      FlatButton(
                                                        child: Text("OK"),
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                      )
                                                    ],
                                                  ),
                                                ));
                                          });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 26,
                          ),
                          CustomTextFormField(
                              controller: _descriptionController,
                              focusNode: FocusNode(),
                              keyboardType: TextInputType.multiline,
                              validator: (value) {
                                return null;
                              },
                              hintText: 'Description',
                              labelText: 'Description',
                              maxLength: 500,
                              minLines: 3,
                              maxLines: 5,
                              obscure: false),
                          Padding(
                            padding: EdgeInsets.all(30),
                          ),
                          Align(
                              alignment: Alignment.bottomRight,
                              child: SizedBox(
                                  width: 200,
                                  height: 50.0,
                                  child: RaisedButton(
                                    color: Theme.of(context).primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          buttonBorderRadius),
                                    ),
                                    onPressed: () async => {
                                      if (_formKey.currentState.validate())
                                        {
                                          service
                                              .updateCurrentUser(
                                            context,
                                            _nameController.text,
                                            _emailController.text,
                                            _phoneController.text,
                                            user.countryCode,
                                            user.dialCode,
                                            _titleController.text,
                                            user.gender,
                                            _descriptionController.text,
                                            birthdayString,
                                          )
                                              .catchError((error) {
                                            CustomFlushbarError(
                                                    title:
                                                        "Something went wrong",
                                                    body:
                                                        "We could not update your profile information. Please make sure you have a valid wifi connection.",
                                                    context: context)
                                                .getFlushbar()
                                                .show(context);
                                          }).then((value) {
                                            CustomFlushbarSuccess(
                                              title:
                                                  "Successfully updated your profile",
                                              body:
                                                  "Your profile was successfully updated.",
                                              context: context,
                                            ).getFlushbar().show(context);
                                            onUpdate();
                                          })
                                        },
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
      ],
    );
  }
}
