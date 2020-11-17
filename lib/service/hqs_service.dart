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

    try {
      token = await client.auth(authUser).then((val) {
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
        Flushbar(
          title: "User successfully updated",
          icon: Icon(
            Icons.check_circle,
            size: 28.0,
            color: Colors.green,
          ),
          flushbarPosition: FlushbarPosition.TOP,
          message: "The user has successfully been updated.",
          margin: EdgeInsets.all(8),
          borderRadius: 8,
          duration: Duration(seconds: 5),
        )..show(context);
        return rep;
      });
    } on GrpcError catch (e) {} catch (e) {}
    curUser = response.user;
    return response;
  }
}
