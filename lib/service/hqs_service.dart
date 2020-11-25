import 'package:flutter/material.dart';
import 'package:hqs_desktop/generated/hqs-user-service/proto/hqs-user-service.pbgrpc.dart'
    as userService;
import 'package:grpc/grpc.dart';
import 'package:flushbar/flushbar.dart';

class HqsService {
  userService.UserServiceClient client;
  userService.Token token = userService.Token();
  userService.User curUser = userService.User();

  final String addr;
  final int port;

  HqsService(this.addr, this.port) {
    client = userService.UserServiceClient(ClientChannel(addr,
        port: port,
        options: const ChannelOptions(
          credentials: ChannelCredentials.insecure(),
        )));
  }

  void retry() {
    client = userService.UserServiceClient(ClientChannel(addr,
        port: port,
        options: const ChannelOptions(
          credentials: ChannelCredentials.insecure(),
        )));
  }

  // methods to call on server
  Future<userService.Token> authenticate(
      BuildContext context, String email, String password) async {
    token.clearToken();

    userService.User authUser = userService.User()
      ..email = email
      ..password = password;

    // validate
    if (email.isEmpty || password.isEmpty) {
      return token;
    }
    // get longitude & latitude
    var metadata = new Map<String, String>();

    /*   try {
      Location location = new Location();
      bool _serviceEnabled;
      PermissionStatus _permissionGranted;
      LocationData _locationData;
      _serviceEnabled = await location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService();
        if (_serviceEnabled) {
          _permissionGranted = await location.hasPermission();
          if (_permissionGranted == PermissionStatus.denied) {
            _permissionGranted = await location.requestPermission();
            if (_permissionGranted == PermissionStatus.granted) {
              _locationData = await location.getLocation();
              metadata = {
                "latitude": _locationData.latitude.toString(),
                "longotude": _locationData.longitude.toString()
              };
            }
          }
        }
      }
    } catch (e) {
      // todo maybe do something
      print("we get in here...");
      print(e);
    } 
    add location on login attempt
    */

    try {
      CallOptions callOptions = CallOptions(metadata: metadata);
      token = await client.auth(authUser, options: callOptions).then((val) {
        return val;
      });
    } on GrpcError catch (e) {
      if ("UNAVAILABLE" == e.codeName) {
        retry();
        Flushbar(
          title: "The service is unaviable",
          icon: Icon(
            Icons.info_outline,
            size: 28.0,
            color: Colors.blue[300],
          ),
          flushbarPosition: FlushbarPosition.TOP,
          message:
              "We could not connect to the service. Please check that you're connected to the internet.",
          margin: EdgeInsets.all(8),
          borderRadius: 8,
          duration: Duration(seconds: 5),
        )..show(context);
      } else if ("UNKNOWN" == e.codeName) {
        token.clearToken();
        Flushbar(
          title: "Could not authenticate",
          icon: Icon(
            Icons.info_outline,
            size: 28.0,
            color: Colors.blue[300],
          ),
          flushbarPosition: FlushbarPosition.TOP,
          message: "The email or password that you provided are not valid",
          margin: EdgeInsets.all(8),
          borderRadius: 8,
          duration: Duration(seconds: 5),
        )..show(context);
      }
    } catch (e) {
      token.clearToken();
      Flushbar(
        title: "Unknown error",
        icon: Icon(
          Icons.warning,
          size: 28.0,
          color: Colors.blue[300],
        ),
        flushbarPosition: FlushbarPosition.TOP,
        message: "An unkown error occured... please try again.",
        margin: EdgeInsets.all(8),
        borderRadius: 8,
        duration: Duration(seconds: 5),
      )..show(context);
    }
    return token;
  }

  Future<userService.Response> getCurrentUser() async {
    userService.Response response = userService.Response();
    if (token == null || token.token.isEmpty) {
      token.clearToken();
      // logout
    }
    try {
      var metadata = {"token": token.token};
      CallOptions callOptions = CallOptions(metadata: metadata);
      response = await client
          .getByToken(userService.Request(), options: callOptions)
          .then((rep) {
        return rep;
      });
    } on GrpcError catch (e) {} catch (e) {}
    curUser = response.user;
    return response;
  }

  Future<userService.Response> updateCurrentUser(
      BuildContext context,
      String name,
      String email,
      String phone,
      String countryCode,
      String dialCode,
      bool gender,
      String description) async {
    userService.Response response = userService.Response();
    if (token == null || token.token.isEmpty) {
      token.clearToken();
      // logout or maybe authenticate again...
    }
    try {
      var metadata = {"token": token.token};
      CallOptions callOptions = CallOptions(metadata: metadata);
      userService.User user = userService.User()
        ..name = name
        ..email = email
        ..phone = phone
        ..dialCode = dialCode
        ..gender = gender
        ..countryCode = countryCode
        ..description = description;
      response =
          await client.updateProfile(user, options: callOptions).then((rep) {
        return rep;
      });
    } on GrpcError catch (e) {
      if ("UNAVAILABLE" == e.codeName) {
        retry();
        Flushbar(
          title: "The service is unaviable",
          icon: Icon(
            Icons.info_outline,
            size: 28.0,
            color: Colors.blue[300],
          ),
          flushbarPosition: FlushbarPosition.TOP,
          message:
              "We could not connect to the service. Please check that you're connected to the internet.",
          margin: EdgeInsets.all(8),
          borderRadius: 8,
          duration: Duration(seconds: 5),
        )..show(context);
      } else if ("UNKNOWN" == e.codeName) {
        //to do logout
        token.clearToken();
        Flushbar(
          title: "Could not authenticate",
          icon: Icon(
            Icons.info_outline,
            size: 28.0,
            color: Colors.blue[300],
          ),
          flushbarPosition: FlushbarPosition.TOP,
          message:
              "We could not authenticate you. Your token might have expired. Try loggin out and in again.",
          margin: EdgeInsets.all(8),
          borderRadius: 8,
          duration: Duration(seconds: 5),
        )..show(context);
      }
    } catch (e) {
      token.clearToken();
      Flushbar(
        title: "Unknown error",
        icon: Icon(
          Icons.warning,
          size: 28.0,
          color: Colors.blue[300],
        ),
        flushbarPosition: FlushbarPosition.TOP,
        message: "An unkown error occured... please try again.",
        margin: EdgeInsets.all(8),
        borderRadius: 8,
        duration: Duration(seconds: 5),
      )..show(context);
    }
    curUser = response.user;
    return response;
  }

  Future<userService.Response> updateCurrentUserPassword(
    BuildContext context,
    String oldPassword,
    String newPassword,
  ) async {
    userService.Response response = userService.Response();
    if (token == null || token.token.isEmpty) {
      token.clearToken();
      // logout or maybe authenticate again...
    }
    try {
      var metadata = {"token": token.token};
      CallOptions callOptions = CallOptions(metadata: metadata);
      userService.UpdatePasswordRequest updatePasswordRequest =
          userService.UpdatePasswordRequest()
            ..oldPassword = oldPassword
            ..newPassword = newPassword;
      response = await client
          .updatePassword(updatePasswordRequest, options: callOptions)
          .then((rep) {
        Flushbar(
          title: "Password successfully updated",
          icon: Icon(
            Icons.check_circle,
            size: 28.0,
            color: Colors.green,
          ),
          flushbarPosition: FlushbarPosition.TOP,
          message: "Your password has successfully been updated.",
          margin: EdgeInsets.all(8),
          borderRadius: 8,
          duration: Duration(seconds: 5),
        )..show(context);
        return rep;
      });
    } on GrpcError catch (e) {
      if ("UNAVAILABLE" == e.codeName) {
        retry();
        Flushbar(
          title: "The service is unaviable",
          icon: Icon(
            Icons.info_outline,
            size: 28.0,
            color: Colors.blue[300],
          ),
          flushbarPosition: FlushbarPosition.TOP,
          message:
              "We could not connect to the service. Please check that you're connected to the internet.",
          margin: EdgeInsets.all(8),
          borderRadius: 8,
          duration: Duration(seconds: 5),
        )..show(context);
      } else if ("UNKNOWN" == e.codeName) {
        //to do logout
        token.clearToken();
        Flushbar(
          title: "Could not validate password",
          icon: Icon(
            Icons.info_outline,
            size: 28.0,
            color: Colors.red[500],
          ),
          flushbarPosition: FlushbarPosition.TOP,
          message:
              "Please make sure that your old password is correct and that your new matches the criterias.",
          margin: EdgeInsets.all(8),
          borderRadius: 8,
          duration: Duration(seconds: 5),
        )..show(context);
      }
    } catch (e) {
      token.clearToken();
      Flushbar(
        title: "Unknown error",
        icon: Icon(
          Icons.warning,
          size: 28.0,
          color: Colors.blue[300],
        ),
        flushbarPosition: FlushbarPosition.TOP,
        message: "An unkown error occured... please try again.",
        margin: EdgeInsets.all(8),
        borderRadius: 8,
        duration: Duration(seconds: 5),
      )..show(context);
    }
    curUser = response.user;
    return response;
  }

  Future<userService.AuthHistory> getCurrentUserAuthHistory() async {
    userService.AuthHistory authHistory = userService.AuthHistory();
    if (token == null || token.token.isEmpty) {
      token.clearToken();
      // logout
    }
    try {
      var metadata = {"token": token.token};
      CallOptions callOptions = CallOptions(metadata: metadata);
      authHistory = await client
          .getAuthHistory(userService.Request(), options: callOptions);
    } on GrpcError catch (e) {} catch (e) {}
    return authHistory;
  }
}
