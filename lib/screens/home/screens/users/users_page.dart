import 'package:flutter/material.dart';
import 'package:hqs_desktop/constants/constants.dart';
import 'package:hqs_desktop/generated/hqs-user-service/proto/hqs-user-service.pb.dart';
import 'package:hqs_desktop/screens/home/screens/users/utils/users_source.dart';
import 'package:hqs_desktop/screens/home/widgets/home_appbar.dart';
import 'package:hqs_desktop/screens/home/widgets/drawer.dart';
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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      drawer: HomeDrawer(
        service: service,
      ),
      appBar: HomeAppBar(
        title: "Profile",
        shadow: true,
        service: service,
      ),
      body: SingleChildScrollView(
          child: FutureBuilder<Response>(
              future: usersResponse,
              builder:
                  (BuildContext context, AsyncSnapshot<Response> snapshot) {
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
                    final usersSource = UsersSource(
                      onRowSelect: (index) {},
                      usersData: users,
                    );
                    return Container(
                        width: size.width,
                        child: Padding(
                            padding: EdgeInsets.all(16),
                            child: PaginatedDataTable(
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
                                                bool isBlocked = false;
                                                final _formKey =
                                                    GlobalKey<FormState>();
                                                return AlertDialog(
                                                    title: Text(
                                                      "Generate Signup Link",
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize: 22,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.grey[900],
                                                      ),
                                                    ),
                                                    content: Container(
                                                      width: 800,
                                                      height: 450,
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            "The system requires valid access codes. To grant create access, one has to to grant the user view and permission access as well. To grant delete, permission or block access, one also has to grant the user view access.",
                                                            style: GoogleFonts
                                                                .poppins(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: Colors
                                                                  .grey[600],
                                                            ),
                                                          ),
                                                          SizedBox(height: 32),
                                                          Form(
                                                            key: _formKey,
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: <
                                                                  Widget>[
                                                                Row(children: [
                                                                  Flexible(
                                                                    child: Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment
                                                                                .start,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                              "Select View Access"),
                                                                          SizedBox(
                                                                            height:
                                                                                8,
                                                                          ),
                                                                          DropdownButtonFormField(
                                                                            decoration:
                                                                                InputDecoration(
                                                                              focusedBorder: OutlineInputBorder(
                                                                                borderSide: BorderSide(color: kPrimaryColor, width: 1.0),
                                                                              ),
                                                                              enabledBorder: OutlineInputBorder(
                                                                                borderSide: BorderSide(color: Colors.grey[300], width: 1.0),
                                                                              ),
                                                                            ),
                                                                            hint:
                                                                                Text('Select View Access'),
                                                                            items: [
                                                                              DropdownMenuItem(
                                                                                child: Text('true'),
                                                                                value: true,
                                                                              ),
                                                                              DropdownMenuItem(
                                                                                child: Text('false'),
                                                                                value: false,
                                                                              ),
                                                                            ],
                                                                        
                                                                            value:
                                                                                allowView,
                                                                            onChanged:
                                                                                (value) {
                                                                              setState(() {
                                                                                allowView = value;
                                                                              });
                                                                            },
                                                                            isExpanded:
                                                                                true,
                                                                          ),
                                                                        ]),
                                                                  ),
                                                                  SizedBox(
                                                                      width:
                                                                          18),
                                                                  Flexible(
                                                                    child: Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment
                                                                                .start,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                              "Select Create Access"),
                                                                          SizedBox(
                                                                            height:
                                                                                8,
                                                                          ),
                                                                          DropdownButtonFormField(
                                                                            decoration:
                                                                                InputDecoration(
                                                                              focusedBorder: OutlineInputBorder(
                                                                                borderSide: BorderSide(color: kPrimaryColor, width: 1.0),
                                                                              ),
                                                                              enabledBorder: OutlineInputBorder(
                                                                                borderSide: BorderSide(color: Colors.grey[300], width: 1.0),
                                                                              ),
                                                                            ),
                                                                            validator:
                                                                                (value) {
                                                                              if (allowBlock && (!allowView || !allowPermission)) {
                                                                                return "Create access requires view & permission access";
                                                                              }
                                                                              return null;
                                                                            },
                                                                        
                                                                            hint:
                                                                                Text('Select Create Access'),
                                                                            items: [
                                                                              DropdownMenuItem(
                                                                                child: Text('true'),
                                                                                value: true,
                                                                              ),
                                                                              DropdownMenuItem(
                                                                                child: Text('false'),
                                                                                value: false,
                                                                              ),
                                                                            ],
                                                                            value:
                                                                                allowCreate,
                                                                            onChanged:
                                                                                (value) {
                                                                              setState(() {
                                                                                allowCreate = value;
                                                                              });
                                                                            },
                                                                            isExpanded:
                                                                                true,
                                                                          ),
                                                                        ]),
                                                                  ),
                                                                ]),
                                                                SizedBox(
                                                                    height: 12),
                                                                Row(children: [
                                                                  Flexible(
                                                                    child: Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment
                                                                                .start,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                              "Select Permission Access"),
                                                                          SizedBox(
                                                                            height:
                                                                                8,
                                                                          ),
                                                                          DropdownButtonFormField(
                                                                            decoration:
                                                                                InputDecoration(
                                                                              focusedBorder: OutlineInputBorder(
                                                                                borderSide: BorderSide(color: kPrimaryColor, width: 1.0),
                                                                              ),
                                                                              enabledBorder: OutlineInputBorder(
                                                                                borderSide: BorderSide(color: Colors.grey[300], width: 1.0),
                                                                              ),
                                                                            ),
                                                                            validator:
                                                                                (value) {
                                                                              if (allowPermission && !allowView) {
                                                                                return "Permission access requires view access";
                                                                              }
                                                                              return null;
                                                                            },
                                                                        
                                                                            hint:
                                                                                Text('Select Permission Access'),
                                                                            items: [
                                                                              DropdownMenuItem(
                                                                                child: Text('true'),
                                                                                value: true,
                                                                              ),
                                                                              DropdownMenuItem(
                                                                                child: Text('false'),
                                                                                value: false,
                                                                              ),
                                                                            ],
                                                                            value:
                                                                                allowPermission,
                                                                            onChanged:
                                                                                (value) {
                                                                              setState(() {
                                                                                allowPermission = value;
                                                                              });
                                                                            },
                                                                            isExpanded:
                                                                                true,
                                                                          ),
                                                                        ]),
                                                                  ),
                                                                  SizedBox(
                                                                      width:
                                                                          18),
                                                                  Flexible(
                                                                    child: Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment
                                                                                .start,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                              "Select Delete Access"),
                                                                          SizedBox(
                                                                            height:
                                                                                8,
                                                                          ),
                                                                          DropdownButtonFormField(
                                                                            decoration:
                                                                                InputDecoration(
                                                                              focusedBorder: OutlineInputBorder(
                                                                                borderSide: BorderSide(color: kPrimaryColor, width: 1.0),
                                                                              ),
                                                                              enabledBorder: OutlineInputBorder(
                                                                                borderSide: BorderSide(color: Colors.grey[300], width: 1.0),
                                                                              ),
                                                                            ),
                                                                            validator:
                                                                                (value) {
                                                                              if (allowDelete && !allowView) {
                                                                                return "Delete access requires view access";
                                                                              }
                                                                              return null;
                                                                            },
                                                                        
                                                                            hint:
                                                                                Text('Select Delete Access'),
                                                                            items: [
                                                                              DropdownMenuItem(
                                                                                child: Text('true'),
                                                                                value: true,
                                                                              ),
                                                                              DropdownMenuItem(
                                                                                child: Text('false'),
                                                                                value: false,
                                                                              ),
                                                                            ],
                                                                            value:
                                                                                allowDelete,
                                                                            onChanged:
                                                                                (value) {
                                                                              setState(() {
                                                                                allowDelete = value;
                                                                              });
                                                                            },
                                                                            isExpanded:
                                                                                true,
                                                                          ),
                                                                        ]),
                                                                  ),
                                                                ]),
                                                                SizedBox(
                                                                    height: 12),
                                                                Row(children: [
                                                                  Flexible(
                                                                    child: Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment
                                                                                .start,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                              "Select Block Access"),
                                                                          SizedBox(
                                                                            height:
                                                                                8,
                                                                          ),
                                                                          DropdownButtonFormField(
                                                                            decoration:
                                                                                InputDecoration(
                                                                              focusedBorder: OutlineInputBorder(
                                                                                borderSide: BorderSide(color: kPrimaryColor, width: 1.0),
                                                                              ),
                                                                              enabledBorder: OutlineInputBorder(
                                                                                borderSide: BorderSide(color: Colors.grey[300], width: 1.0),
                                                                              ),
                                                                            ),
                                                                            validator:
                                                                                (value) {
                                                                              if (allowBlock && !allowView) {
                                                                                return "Block access requires view access";
                                                                              }
                                                                              return null;
                                                                            },
                                                                        
                                                                            hint:
                                                                                Text('Select Block Access'),
                                                                            items: [
                                                                              DropdownMenuItem(
                                                                                child: Text('true'),
                                                                                value: true,
                                                                              ),
                                                                              DropdownMenuItem(
                                                                                child: Text('false'),
                                                                                value: false,
                                                                              ),
                                                                            ],
                                                                            value:
                                                                                allowBlock,
                                                                            onChanged:
                                                                                (value) {
                                                                              setState(() {
                                                                                allowBlock = value;
                                                                              });
                                                                            },
                                                                            isExpanded:
                                                                                true,
                                                                          ),
                                                                        ]),
                                                                  ),
                                                                  SizedBox(
                                                                      width:
                                                                          18),
                                                                  Flexible(
                                                                    child: Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment
                                                                                .start,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                              "Is Blocked?"),
                                                                          SizedBox(
                                                                            height:
                                                                                8,
                                                                          ),
                                                                          DropdownButtonFormField(
                                                                            decoration:
                                                                                InputDecoration(
                                                                              focusedBorder: OutlineInputBorder(
                                                                                borderSide: BorderSide(color: kPrimaryColor, width: 1.0),
                                                                              ),
                                                                              enabledBorder: OutlineInputBorder(
                                                                                borderSide: BorderSide(color: Colors.grey[300], width: 1.0),
                                                                              ),
                                                                            ),
                                                                        
                                                                            hint:
                                                                                Text('Is blocked?'),
                                                                            items: [
                                                                              DropdownMenuItem(
                                                                                child: Text('true'),
                                                                                value: true,
                                                                              ),
                                                                              DropdownMenuItem(
                                                                                child: Text('false'),
                                                                                value: false,
                                                                              ),
                                                                            ],
                                                                            value:
                                                                                isBlocked,
                                                                            onChanged:
                                                                                (value) {
                                                                              setState(() {
                                                                                isBlocked = value;
                                                                              });
                                                                            },
                                                                            isExpanded:
                                                                                true,
                                                                          ),
                                                                        ]),
                                                                  ),
                                                                ]),
                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(height: 18),
                                                          Center(
                                                            child: Flexible(
                                                              child: Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Colors
                                                                          .grey[
                                                                      100],
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              cardBorderRadius),
                                                                ),
                                                                width: 750,
                                                                height: 50,
                                                                child:
                                                                    TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    FlutterClipboard.copy(
                                                                            'hello flutter friends')
                                                                        .then(
                                                                            (value) {
                                                                      Flushbar(
                                                                        title:
                                                                            "Token Copied",
                                                                        maxWidth:
                                                                            450,
                                                                        icon:
                                                                            Icon(
                                                                          Icons
                                                                              .check_circle,
                                                                          size:
                                                                              28.0,
                                                                          color:
                                                                              Colors.green,
                                                                        ),
                                                                        flushbarPosition:
                                                                            FlushbarPosition.TOP,
                                                                        message:
                                                                            "Token has been copied. Send it to a new team member so he can signup!",
                                                                        margin:
                                                                            EdgeInsets.all(8),
                                                                        borderRadius:
                                                                            8,
                                                                        duration:
                                                                            Duration(seconds: 5),
                                                                      )..show(
                                                                          context);
                                                                    });
                                                                  },
                                                                  child: Text(
                                                                    "Not generated yet",
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
                                                          style: GoogleFonts
                                                              .poppins(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            color: Colors.red,
                                                          ),
                                                        ),
                                                        onPressed: () {
                                                          Navigator.of(context,
                                                                  rootNavigator:
                                                                      true)
                                                              .pop();
                                                        },
                                                      ),
                                                      TextButton(
                                                        child: Text(
                                                          "Generate",
                                                          style: GoogleFonts
                                                              .poppins(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            color:
                                                                kPrimaryColor,
                                                          ),
                                                        ),
                                                        onPressed: () {
                                                          if (_formKey
                                                              .currentState
                                                              .validate()) {}
                                                        },
                                                      ),
                                                    ]);
                                              });
                                        },
                                        color: Colors.amber[700],
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              cardBorderRadius),
                                        ),
                                        child: Text("Generate Signup Link"),
                                        textColor: Colors.white,
                                      )),
                                  SizedBox(
                                      width: 130,
                                      height: 45.0,
                                      child: RaisedButton(
                                        onPressed: () {},
                                        color: kPrimaryColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              cardBorderRadius),
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
                                  "All Users",
                                  style: GoogleFonts.poppins(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                  ),
                                ),
                                columns: _colGen(usersSource))));
                }
                ;
              })),
    );
  }

  List<DataColumn> _colGen(
    UsersSource _src,
    //UserDataNotifier _provider,
  ) =>
      <DataColumn>[
        DataColumn(
          label: Text("Name"),
        ),
        DataColumn(
          label: Text("Created At"),
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
      ];
}
