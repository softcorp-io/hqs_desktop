import 'package:flutter/material.dart';
import 'package:hqs_desktop/constants/constants.dart';
import 'package:hqs_desktop/generated/hqs-user-service/proto/hqs-user-service.pb.dart';
import 'package:hqs_desktop/screens/home/screens/users/utils/users_source.dart';
import 'package:hqs_desktop/screens/home/widgets/custom_dropdown_form_field.dart';
import 'package:hqs_desktop/screens/home/widgets/custom_text_form_field.dart';
import 'package:hqs_desktop/service/hqs_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flushbar/flushbar.dart';

/// This is the stateless widget that the main application instantiates.
class UsersPage extends StatefulWidget {
  final HqsService service;

  UsersPage({@required this.service}) : assert(service != null);

  @override
  _UsersPageState createState() => _UsersPageState(service: service);
}

class _UsersPageState extends State<UsersPage> {
  final HqsService service;
  Future<Response> usersResponse;
  List<User> users;
  _UsersPageState({@required this.service}) {
    usersResponse = service.getAllUsers().then((response) {
      this.users = response.users;
      return response;
    });
  }

  void onUpdate() {
    service.getAllUsers().then((value) {
      setState(() {
        users = value.users;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    UsersSource usersSource;
    Size size = MediaQuery.of(context).size;
    return FutureBuilder<Response>(
      future: usersResponse,
      builder: (BuildContext futureContext, AsyncSnapshot<Response> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.active:
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Padding(
                padding: EdgeInsets.only(top: 52),
                child: Align(
                    child: Container(
                      child: CircularProgressIndicator(),
                    ),
                    alignment: Alignment.center));
          case ConnectionState.done:
            usersSource = UsersSource(
              onUpdate: onUpdate,
              buildContext: context,
              service: service,
              onRowSelect: (index) {},
              usersData: users,
            );
            return SingleChildScrollView(
              child: Container(
                width: size.width,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: PaginatedDataTable(
                    columnSpacing: 15,
                    actions: [
                      SizedBox(
                          height: 45.0,
                          child: RaisedButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    bool allowView = false;
                                    bool allowCreate = false;
                                    bool allowDelete = false;
                                    bool allowPermission = false;
                                    bool allowBlock = false;
                                    Token signupToken;
                                    final _formKey = GlobalKey<FormState>();
                                    return StatefulBuilder(
                                        builder: (context, setState) {
                                      return AlertDialog(
                                          title: Text(
                                            "Generate Signup Link",
                                            style: GoogleFonts.poppins(
                                              fontSize: 22,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.grey[900],
                                            ),
                                          ),
                                          content: Container(
                                            width: 800,
                                            height: 550,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "The system requires valid access codes. To grant create access, one has to to grant the user view and permission access as well. To grant delete, permission or block access, one also has to grant the user view access.",
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                                SizedBox(height: 32),
                                                Form(
                                                  key: _formKey,
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: <Widget>[
                                                      Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Flexible(
                                                              child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                        "Select View Access"),
                                                                    SizedBox(
                                                                      height: 8,
                                                                    ),
                                                                    CustomDromDownMenu(
                                                                      validator:
                                                                          (value) {
                                                                        return null;
                                                                      },
                                                                      defaultBorderColor:
                                                                          Colors
                                                                              .grey[200],
                                                                      hintText:
                                                                          'Select View Access',
                                                                      items: [
                                                                        DropdownMenuItem(
                                                                          child:
                                                                              Text('true'),
                                                                          value:
                                                                              true,
                                                                        ),
                                                                        DropdownMenuItem(
                                                                          child:
                                                                              Text('false'),
                                                                          value:
                                                                              false,
                                                                        ),
                                                                      ],
                                                                      value:
                                                                          allowView,
                                                                      onChanged:
                                                                          (value) {
                                                                        setState(
                                                                            () {
                                                                          allowView =
                                                                              value;
                                                                        });
                                                                      },
                                                                    ),
                                                                  ]),
                                                            ),
                                                            SizedBox(width: 18),
                                                            Flexible(
                                                              child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                        "Select Create Access"),
                                                                    SizedBox(
                                                                      height: 8,
                                                                    ),
                                                                    CustomDromDownMenu(
                                                                      validator:
                                                                          (value) {
                                                                        if (allowCreate &&
                                                                            (!allowView ||
                                                                                !allowPermission)) {
                                                                          return "Create access requires view & permission access";
                                                                        }
                                                                        return null;
                                                                      },
                                                                      defaultBorderColor:
                                                                          Colors
                                                                              .grey[200],
                                                                      hintText:
                                                                          'Select Create Access',
                                                                      items: [
                                                                        DropdownMenuItem(
                                                                          child:
                                                                              Text('true'),
                                                                          value:
                                                                              true,
                                                                        ),
                                                                        DropdownMenuItem(
                                                                          child:
                                                                              Text('false'),
                                                                          value:
                                                                              false,
                                                                        ),
                                                                      ],
                                                                      value:
                                                                          allowCreate,
                                                                      onChanged:
                                                                          (value) {
                                                                        setState(
                                                                            () {
                                                                          allowCreate =
                                                                              value;
                                                                        });
                                                                      },
                                                                    ),
                                                                  ]),
                                                            ),
                                                          ]),
                                                      SizedBox(height: 28),
                                                      Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Flexible(
                                                              child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                        "Select Permission Access"),
                                                                    SizedBox(
                                                                      height: 8,
                                                                    ),
                                                                    CustomDromDownMenu(
                                                                      validator:
                                                                          (value) {
                                                                        if (allowPermission &&
                                                                            !allowView) {
                                                                          return "Permission access also requires view access";
                                                                        }
                                                                        return null;
                                                                      },
                                                                      defaultBorderColor:
                                                                          Colors
                                                                              .grey[200],
                                                                      hintText:
                                                                          'Select Permission Access',
                                                                      items: [
                                                                        DropdownMenuItem(
                                                                          child:
                                                                              Text('true'),
                                                                          value:
                                                                              true,
                                                                        ),
                                                                        DropdownMenuItem(
                                                                          child:
                                                                              Text('false'),
                                                                          value:
                                                                              false,
                                                                        ),
                                                                      ],
                                                                      value:
                                                                          allowPermission,
                                                                      onChanged:
                                                                          (value) {
                                                                        setState(
                                                                            () {
                                                                          allowPermission =
                                                                              value;
                                                                        });
                                                                      },
                                                                    ),
                                                                  ]),
                                                            ),
                                                            SizedBox(width: 18),
                                                            Flexible(
                                                              child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                        "Select Delete Access"),
                                                                    SizedBox(
                                                                      height: 8,
                                                                    ),
                                                                    CustomDromDownMenu(
                                                                      validator:
                                                                          (value) {
                                                                        if (allowDelete &&
                                                                            !allowView) {
                                                                          return "Delete access also requires view access";
                                                                        }
                                                                        return null;
                                                                      },
                                                                      defaultBorderColor:
                                                                          Colors
                                                                              .grey[200],
                                                                      hintText:
                                                                          'Select Delte Access',
                                                                      items: [
                                                                        DropdownMenuItem(
                                                                          child:
                                                                              Text('true'),
                                                                          value:
                                                                              true,
                                                                        ),
                                                                        DropdownMenuItem(
                                                                          child:
                                                                              Text('false'),
                                                                          value:
                                                                              false,
                                                                        ),
                                                                      ],
                                                                      value:
                                                                          allowDelete,
                                                                      onChanged:
                                                                          (value) {
                                                                        setState(
                                                                            () {
                                                                          allowDelete =
                                                                              value;
                                                                        });
                                                                      },
                                                                    ),
                                                                  ]),
                                                            ),
                                                          ]),
                                                      SizedBox(height: 28),
                                                      Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Flexible(
                                                              child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                        "Select Block Access"),
                                                                    SizedBox(
                                                                      height: 8,
                                                                    ),
                                                                    CustomDromDownMenu(
                                                                      validator:
                                                                          (value) {
                                                                        if (allowBlock &&
                                                                            !allowView) {
                                                                          return "Block access also requires view access";
                                                                        }
                                                                        return null;
                                                                      },
                                                                      defaultBorderColor:
                                                                          Colors
                                                                              .grey[200],
                                                                      hintText:
                                                                          'Select Block Access',
                                                                      items: [
                                                                        DropdownMenuItem(
                                                                          child:
                                                                              Text('true'),
                                                                          value:
                                                                              true,
                                                                        ),
                                                                        DropdownMenuItem(
                                                                          child:
                                                                              Text('false'),
                                                                          value:
                                                                              false,
                                                                        ),
                                                                      ],
                                                                      value:
                                                                          allowBlock,
                                                                      onChanged:
                                                                          (value) {
                                                                        setState(
                                                                            () {
                                                                          allowBlock =
                                                                              value;
                                                                        });
                                                                      },
                                                                    ),
                                                                  ]),
                                                            ),
                                                          ]),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(height: 28),
                                                Center(
                                                  child: Flexible(
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.grey[100],
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                cardBorderRadius),
                                                      ),
                                                      width: 750,
                                                      height: 50,
                                                      child: TextButton(
                                                        onPressed: () {
                                                          if (signupToken !=
                                                              null) {
                                                            FlutterClipboard.copy(
                                                                    signupToken
                                                                        .token)
                                                                .then((value) {
                                                              Flushbar(
                                                                title:
                                                                    "Token Copied",
                                                                maxWidth: 450,
                                                                icon: Icon(
                                                                  Icons
                                                                      .check_circle,
                                                                  size: 28.0,
                                                                  color: Colors
                                                                      .green,
                                                                ),
                                                                flushbarPosition:
                                                                    FlushbarPosition
                                                                        .TOP,
                                                                message:
                                                                    "Token has been copied. Send it to a new team member so he can signup!",
                                                                margin:
                                                                    EdgeInsets
                                                                        .all(8),
                                                                borderRadius: 8,
                                                                duration:
                                                                    Duration(
                                                                        seconds:
                                                                            5),
                                                              )..show(context);
                                                            });
                                                          }
                                                        },
                                                        child: Text(
                                                          signupToken == null
                                                              ? "Token not generated yet."
                                                              : "Token generated. Click to copy.",
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                              child: Text(
                                                "Close",
                                                style: GoogleFonts.poppins(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.red,
                                                ),
                                              ),
                                              onPressed: () {
                                                Navigator.of(context,
                                                        rootNavigator: true)
                                                    .pop();
                                              },
                                            ),
                                            TextButton(
                                              child: Text(
                                                "Generate",
                                                style: GoogleFonts.poppins(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.normal,
                                                  color: kPrimaryColor,
                                                ),
                                              ),
                                              onPressed: () {
                                                if (_formKey.currentState
                                                    .validate()) {
                                                  service
                                                      .generateSignupToken(
                                                    allowView,
                                                    allowCreate,
                                                    allowPermission,
                                                    allowDelete,
                                                    allowBlock,
                                                  )
                                                      .then((token) {
                                                    setState(() {
                                                      signupToken = token;
                                                    });
                                                  });
                                                }
                                              },
                                            ),
                                          ]);
                                    });
                                  });
                            },
                            color: Colors.amber[700],
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(cardBorderRadius),
                            ),
                            child: Text("Generate Signup Link"),
                            textColor: Colors.white,
                          )),
                      SizedBox(
                          width: 130,
                          height: 45.0,
                          child: RaisedButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    bool allowView = false;
                                    bool allowCreate = false;
                                    bool allowDelete = false;
                                    bool allowPermission = false;
                                    bool allowBlock = false;
                                    final _nameController =
                                        TextEditingController();
                                    final _emailController =
                                        TextEditingController();
                                    final _passwordController =
                                        TextEditingController();
                                    final _formKey = GlobalKey<FormState>();
                                    return StatefulBuilder(
                                        builder: (context, setState) {
                                      return AlertDialog(
                                          title: Text(
                                            "Create User",
                                            style: GoogleFonts.poppins(
                                              fontSize: 22,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.grey[900],
                                            ),
                                          ),
                                          content: Container(
                                            width: 800,
                                            height: 550,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "The system requires valid access codes. To grant create access, one has to to grant the user view and permission access as well. To grant delete, permission or block access, one also has to grant the user view access.",
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.grey[600],
                                                  ),
                                                ),
                                                SizedBox(height: 32),
                                                Form(
                                                  key: _formKey,
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: <Widget>[
                                                      Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Flexible(
                                                              child:
                                                                  CustomTextFormField(
                                                                defaultBorderColor:
                                                                    Colors.grey[
                                                                        300],
                                                                controller:
                                                                    _nameController,
                                                                hintText:
                                                                    'Name',
                                                                labelText:
                                                                    'Name',
                                                                obscure: false,
                                                                icon: Icon(
                                                                  Icons.person,
                                                                ),
                                                                validator:
                                                                    (value) {
                                                                  if (value
                                                                      .isEmpty) {
                                                                    return "Please enter a valid name";
                                                                  }
                                                                  return null;
                                                                },
                                                              ),
                                                            ),
                                                            SizedBox(width: 16),
                                                            Flexible(
                                                              child:
                                                                  CustomTextFormField(
                                                                defaultBorderColor:
                                                                    Colors.grey[
                                                                        300],
                                                                controller:
                                                                    _emailController,
                                                                hintText:
                                                                    'Email',
                                                                labelText:
                                                                    'Email',
                                                                obscure: false,
                                                                icon: Icon(
                                                                  Icons
                                                                      .mail_outline_rounded,
                                                                ),
                                                                validator:
                                                                    (value) {
                                                                  var validEmail = RegExp(
                                                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                                                      .hasMatch(
                                                                          value);
                                                                  if (!validEmail) {
                                                                    return "Please enter a valid email";
                                                                  }
                                                                  return null;
                                                                },
                                                              ),
                                                            ),
                                                          ]),
                                                      SizedBox(height: 30),
                                                      Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Flexible(
                                                              child: Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        top:
                                                                            28),
                                                                child:
                                                                    CustomTextFormField(
                                                                  defaultBorderColor:
                                                                      Colors.grey[
                                                                          300],
                                                                  controller:
                                                                      _passwordController,
                                                                  hintText:
                                                                      'Password',
                                                                  labelText:
                                                                      'Password',
                                                                  obscure: true,
                                                                  icon: Icon(
                                                                      Icons
                                                                          .lock),
                                                                  validator:
                                                                      (value) {
                                                                    if (value
                                                                            .length <
                                                                        6) {
                                                                      return "Please enter a valid password";
                                                                    }
                                                                    return null;
                                                                  },
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(width: 18),
                                                            Flexible(
                                                              child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                        "Select View Access"),
                                                                    SizedBox(
                                                                      height: 8,
                                                                    ),
                                                                    CustomDromDownMenu(
                                                                      validator:
                                                                          (value) {
                                                                        return null;
                                                                      },
                                                                      defaultBorderColor:
                                                                          Colors
                                                                              .grey[200],
                                                                      hintText:
                                                                          'Select View Access',
                                                                      items: [
                                                                        DropdownMenuItem(
                                                                          child:
                                                                              Text('true'),
                                                                          value:
                                                                              true,
                                                                        ),
                                                                        DropdownMenuItem(
                                                                          child:
                                                                              Text('false'),
                                                                          value:
                                                                              false,
                                                                        ),
                                                                      ],
                                                                      value:
                                                                          allowView,
                                                                      onChanged:
                                                                          (value) {
                                                                        setState(
                                                                            () {
                                                                          allowView =
                                                                              value;
                                                                        });
                                                                      },
                                                                    ),
                                                                  ]),
                                                            ),
                                                          ]),
                                                      SizedBox(height: 28),
                                                      Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Flexible(
                                                              child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                        "Select Create Access"),
                                                                    SizedBox(
                                                                      height: 8,
                                                                    ),
                                                                    CustomDromDownMenu(
                                                                      validator:
                                                                          (value) {
                                                                        if (allowCreate &&
                                                                            !(allowView &&
                                                                                allowPermission)) {
                                                                          return "Create access requires permission and view access";
                                                                        }
                                                                        return null;
                                                                      },
                                                                      defaultBorderColor:
                                                                          Colors
                                                                              .grey[200],
                                                                      hintText:
                                                                          'Select Create Access',
                                                                      items: [
                                                                        DropdownMenuItem(
                                                                          child:
                                                                              Text('true'),
                                                                          value:
                                                                              true,
                                                                        ),
                                                                        DropdownMenuItem(
                                                                          child:
                                                                              Text('false'),
                                                                          value:
                                                                              false,
                                                                        ),
                                                                      ],
                                                                      value:
                                                                          allowCreate,
                                                                      onChanged:
                                                                          (value) {
                                                                        setState(
                                                                            () {
                                                                          allowCreate =
                                                                              value;
                                                                        });
                                                                      },
                                                                    ),
                                                                  ]),
                                                            ),
                                                            SizedBox(width: 18),
                                                            Flexible(
                                                              child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                        "Select Permission Access"),
                                                                    SizedBox(
                                                                      height: 8,
                                                                    ),
                                                                    CustomDromDownMenu(
                                                                      validator:
                                                                          (value) {
                                                                        if (allowPermission &&
                                                                            !allowView) {
                                                                          return "Permission access also requires view access";
                                                                        }
                                                                        return null;
                                                                      },
                                                                      defaultBorderColor:
                                                                          Colors
                                                                              .grey[200],
                                                                      hintText:
                                                                          'Select Permission Access',
                                                                      items: [
                                                                        DropdownMenuItem(
                                                                          child:
                                                                              Text('true'),
                                                                          value:
                                                                              true,
                                                                        ),
                                                                        DropdownMenuItem(
                                                                          child:
                                                                              Text('false'),
                                                                          value:
                                                                              false,
                                                                        ),
                                                                      ],
                                                                      value:
                                                                          allowPermission,
                                                                      onChanged:
                                                                          (value) {
                                                                        setState(
                                                                            () {
                                                                          allowPermission =
                                                                              value;
                                                                        });
                                                                      },
                                                                    ),
                                                                  ]),
                                                            ),
                                                          ]),
                                                      SizedBox(height: 28),
                                                      Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Flexible(
                                                              child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                        "Select Delete Access"),
                                                                    SizedBox(
                                                                      height: 8,
                                                                    ),
                                                                    CustomDromDownMenu(
                                                                      validator:
                                                                          (value) {
                                                                        if (allowDelete &&
                                                                            !allowView) {
                                                                          return "Delete access also requires view access";
                                                                        }
                                                                        return null;
                                                                      },
                                                                      defaultBorderColor:
                                                                          Colors
                                                                              .grey[200],
                                                                      hintText:
                                                                          'Select Delte Access',
                                                                      items: [
                                                                        DropdownMenuItem(
                                                                          child:
                                                                              Text('true'),
                                                                          value:
                                                                              true,
                                                                        ),
                                                                        DropdownMenuItem(
                                                                          child:
                                                                              Text('false'),
                                                                          value:
                                                                              false,
                                                                        ),
                                                                      ],
                                                                      value:
                                                                          allowDelete,
                                                                      onChanged:
                                                                          (value) {
                                                                        setState(
                                                                            () {
                                                                          allowDelete =
                                                                              value;
                                                                        });
                                                                      },
                                                                    ),
                                                                  ]),
                                                            ),
                                                            SizedBox(width: 18),
                                                            Flexible(
                                                              child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                        "Select Block Access"),
                                                                    SizedBox(
                                                                      height: 8,
                                                                    ),
                                                                    CustomDromDownMenu(
                                                                      validator:
                                                                          (value) {
                                                                        if (allowBlock &&
                                                                            !allowView) {
                                                                          return "Block access also requires view access";
                                                                        }
                                                                        return null;
                                                                      },
                                                                      defaultBorderColor:
                                                                          Colors
                                                                              .grey[200],
                                                                      hintText:
                                                                          'Select Block Access',
                                                                      items: [
                                                                        DropdownMenuItem(
                                                                          child:
                                                                              Text('true'),
                                                                          value:
                                                                              true,
                                                                        ),
                                                                        DropdownMenuItem(
                                                                          child:
                                                                              Text('false'),
                                                                          value:
                                                                              false,
                                                                        ),
                                                                      ],
                                                                      value:
                                                                          allowBlock,
                                                                      onChanged:
                                                                          (value) {
                                                                        setState(
                                                                            () {
                                                                          allowBlock =
                                                                              value;
                                                                        });
                                                                      },
                                                                    ),
                                                                  ]),
                                                            ),
                                                          ]),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                              child: Text(
                                                "Close",
                                                style: GoogleFonts.poppins(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.red,
                                                ),
                                              ),
                                              onPressed: () {
                                                Navigator.of(context,
                                                        rootNavigator: true)
                                                    .pop();
                                              },
                                            ),
                                            TextButton(
                                              child: Text(
                                                "Create",
                                                style: GoogleFonts.poppins(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.normal,
                                                  color: kPrimaryColor,
                                                ),
                                              ),
                                              onPressed: () {
                                                if (_formKey.currentState
                                                    .validate()) {
                                                  service
                                                      .createUser(
                                                    _nameController.text,
                                                    _emailController.text,
                                                    _passwordController.text,
                                                    allowView,
                                                    allowCreate,
                                                    allowPermission,
                                                    allowDelete,
                                                    allowBlock,
                                                  )
                                                      .catchError((error) {
                                                    Flushbar(
                                                      title:
                                                          "Something went wrong",
                                                      maxWidth: 800,
                                                      icon: Icon(
                                                        Icons.error_outline,
                                                        size: 28.0,
                                                        color: Colors.red[600],
                                                      ),
                                                      flushbarPosition:
                                                          FlushbarPosition.TOP,
                                                      message:
                                                          "Could not create user. Please check that you have a valid wifi connection.",
                                                      margin: EdgeInsets.all(8),
                                                      borderRadius: 8,
                                                      duration:
                                                          Duration(seconds: 5),
                                                    )..show(context);
                                                  }).then((response) {
                                                    service
                                                        .getAllUsers()
                                                        .then((value) {
                                                      setState(() {});
                                                    });
                                                    onUpdate();
                                                    Navigator.of(context,
                                                            rootNavigator: true)
                                                        .pop();
                                                    Flushbar(
                                                      title:
                                                          "User successfully created!",
                                                      maxWidth: 800,
                                                      icon: Icon(
                                                        Icons.check_circle,
                                                        size: 28.0,
                                                        color: Colors.green,
                                                      ),
                                                      flushbarPosition:
                                                          FlushbarPosition.TOP,
                                                      message:
                                                          "The user has successfully been created. ",
                                                      margin: EdgeInsets.all(8),
                                                      borderRadius: 8,
                                                      duration:
                                                          Duration(seconds: 5),
                                                    )..show(context);
                                                  });
                                                }
                                              },
                                            ),
                                          ]);
                                    });
                                  });
                            },
                            color: kPrimaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(cardBorderRadius),
                            ),
                            child: Text("New User"),
                            textColor: Colors.white,
                          )),
                    ],
                    headingRowHeight: 80,
                    dataRowHeight: 80,
                    rowsPerPage: 10,
                    source: usersSource,
                    header: Text(
                      "Manage Users",
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    columns: _colGen(usersSource),
                  ),
                ),
              ),
            );
        }
        ;
      },
    );
  }

  List<DataColumn> _colGen(
    UsersSource _src,
    //UserDataNotifier _provider,
  ) =>
      <DataColumn>[
        DataColumn(
          label: Text("Image"),
        ),
        DataColumn(
          label: Text("Name"),
        ),
        DataColumn(
          label: Text("View Access"),
        ),
        DataColumn(
          label: Text("Create Access"),
        ),
        DataColumn(
          label: Text("Permission Access"),
        ),
        DataColumn(
          label: Text("Delete Access"),
        ),
        DataColumn(
          label: Text("Block Access"),
        ),
        DataColumn(
          label: Text("Blocked"),
        ),
        DataColumn(
          label: Text("Actions"),
        ),
      ];
}
