import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hqs_desktop/constants/constants.dart';
import 'package:hqs_desktop/generated/hqs-user-service/proto/hqs-user-service.pb.dart';
import 'package:hqs_desktop/service/hqs_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:country_code_picker/country_code_picker.dart';

class ProfileFormCard extends StatefulWidget {
  final HqsService service;
  final User user;
  final Function onUpdate;
  final double profileImageRadius;

  ProfileFormCard(
      {@required this.service, @required this.user, @required this.onUpdate, @required this.profileImageRadius})
      : assert(service != null),
        assert(profileImageRadius != null);

  @override
  _ProfileFormCardState createState() =>
      _ProfileFormCardState(service: service, user: user, onUpdate: onUpdate, profileImageRadius: profileImageRadius);
}

class _ProfileFormCardState extends State<ProfileFormCard> {
  // form controllers
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _phoneController = TextEditingController();
  String countryCode = "";
  String dialCode = "";

  // constructor parameters
  final HqsService service;
  final User user;
  final Function onUpdate;
  final double profileImageRadius;

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

  _ProfileFormCardState(
      {@required this.service, @required this.user, @required this.onUpdate, @required this.profileImageRadius}) {
    assert(service != null);
    assert(user != null);
    assert(profileImageRadius != null);
    _nameController.text = user.name;
    _emailController.text = user.email;
    _descriptionController.text = user.description;
    _selectedGender = user.gender;
    _phoneController.text = user.phone;
    countryCode = user.countryCode;
    dialCode = user.dialCode;
  }

  @override
  Widget build(BuildContext context) {
    loadGenderList();
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 120/2),
          child: Card(
            elevation: 4,
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(25),
              ),
            ),
            child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(40),
                  child: Column(
                    children: [
                      Align(
                        child: Text(
                          "Edit Profile",
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
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Flexible(
                                  child: TextFormField(
                                    controller: _nameController,
                                    decoration: InputDecoration(
                                      hintText: 'Name',
                                      labelText: 'Name',
                                      suffixIcon: Icon(
                                        Icons.person_outline,
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return "Please specify a valid name";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(12),
                                ),
                                Flexible(
                                  child: TextFormField(
                                    controller: _emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                      hintText: 'Email',
                                      labelText: 'Email',
                                      suffixIcon: Icon(
                                        Icons.mail_outline,
                                      ),
                                    ),
                                    validator: (value) {
                                      var validEmail = RegExp(
                                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                          .hasMatch(value);
                                      if (!validEmail) {
                                        return "Please enter a valid email";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 14,
                            ),
                            Row(
                              children: <Widget>[
                                Flexible(
                                  child: DropdownButtonFormField(
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
                                      Expanded(
                                        child: TextFormField(
                                          controller: _phoneController,
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ],
                                          keyboardType: TextInputType.phone,
                                          decoration: InputDecoration(
                                            hintText: 'Phone',
                                            labelText: 'Phone',
                                            suffixIcon: Icon(
                                              Icons.phone,
                                            ),
                                          ),
                                          validator: (value) {
                                            var validPhone =
                                                RegExp(r"^(?:[0]9)?[0-9]*")
                                                    .hasMatch(value);
                                            if (!validPhone) {
                                              return "Please enter a valid phone";
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
                              height: 16,
                            ),
                            Text(
                              "Description",
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[800],
                              ),
                            ),
                            TextField(
                              keyboardType: TextInputType.multiline,
                              controller: _descriptionController,
                              minLines: 1,
                              maxLength: 200,
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
                                        borderRadius:
                                            BorderRadius.circular(18.0),
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
                                                    _selectedGender,
                                                    _descriptionController.text)
                                                .then((value) {
                                              if (value != null) {
                                                onUpdate();
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
      ],
    );
  }
}