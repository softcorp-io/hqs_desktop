import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hqs_desktop/generated/google/protobuf/timestamp.pbserver.dart';
import 'package:hqs_desktop/generated/hqs-user-service/proto/hqs-user-service.pbgrpc.dart'
    as userService;
import 'package:grpc/grpc.dart';
import 'package:file_picker_cross/file_picker_cross.dart';

class HqsService {
  userService.UserServiceClient client;
  userService.Token token = userService.Token();
  userService.User curUser = userService.User();

  final String addr;
  final int port;
  Function onLogout;

  HqsService({@required this.addr, @required this.port}) {
    assert(addr != null);
    assert(port != null);

    client = userService.UserServiceClient(ClientChannel(addr,
        port: port,
        options: const ChannelOptions(
          credentials: ChannelCredentials.insecure(),
        )));
  }

  void setLogout(Function logout) {
    onLogout = logout;
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
    var metadata = {
      "latitude": "0.0",
      "longitude": "0.0",
    };
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
      getCurrentUser();
    } catch (e) {
      throw GrpcError;
    }
    return token;
  }

  Future<userService.Response> getCurrentUser() async {
    userService.Response response = userService.Response();

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

  Future<userService.Response> createUser(
      String name,
      String email,
      String password,
      bool allowView,
      bool allowCreate,
      bool allowPermission,
      bool allowDelete,
      bool allowBlock) async {
    userService.Response response = userService.Response();

    try {
      var metadata = {"token": token.token};
      CallOptions callOptions = CallOptions(metadata: metadata);
      response = await client
          .create(
              userService.User()
                ..name = name
                ..email = email
                ..password = password
                ..allowView = allowView
                ..allowCreate = allowCreate
                ..allowPermission = allowPermission
                ..allowDelete = allowDelete
                ..allowBlock = allowBlock,
              options: callOptions)
          .then((rep) {
        return rep;
      });
    } on GrpcError catch (e) {} catch (e) {}
    return response;
  }

  Future<userService.Response> blockUser(userService.User user) async {
    userService.Response response = userService.Response();

    try {
      var metadata = {"token": token.token};
      CallOptions callOptions = CallOptions(metadata: metadata);
      response = await client
          .updateBlockUser(
              userService.User()
                ..blocked = !user.blocked
                ..id = user.id,
              options: callOptions)
          .then((rep) {
        return rep;
      });
    } on GrpcError catch (e) {} catch (e) {}
    return response;
  }

  Future<userService.Response> updateUsersPermissions(
    String id,
    bool allowView,
    bool allowCreate,
    bool allowPermissions,
    bool allowDelete,
    bool allowBlock,
  ) async {
    userService.Response response = userService.Response();
    try {
      var metadata = {"token": token.token};
      CallOptions callOptions = CallOptions(metadata: metadata);
      response = await client
          .updateAllowances(
              userService.User()
                ..id = id
                ..allowView = allowView
                ..allowCreate = allowCreate
                ..allowPermission = allowPermissions
                ..allowDelete = allowDelete
                ..allowBlock = allowBlock,
              options: callOptions)
          .then((rep) {
        getCurrentUser();
        return rep;
      });
    } on GrpcError catch (e) {} catch (e) {}
    return response;
  }

  Future<userService.Response> getAllUsers() async {
    userService.Response response = userService.Response();

    try {
      var metadata = {"token": token.token};
      CallOptions callOptions = CallOptions(metadata: metadata);
      response = await client
          .getAll(userService.Request(), options: callOptions)
          .then((rep) {
        return rep;
      });
    } on GrpcError catch (e) {} catch (e) {}
    return response;
  }

  Future<userService.Response> updateCurrentUser(
      BuildContext context,
      String name,
      String email,
      String phone,
      String countryCode,
      String dialCode,
      String title,
      bool gender,
      String description,
      DateTime birthDate) async {
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
        ..title = title
        ..birthDate = Timestamp.fromDateTime(birthDate.add(Duration(hours: 9)))
        ..description = description;
      response =
          await client.updateProfile(user, options: callOptions).then((rep) {
        return rep;
      });
    } catch (e) {
      throw GrpcError;
    }
    curUser.name = response.user.name;
    curUser.email = response.user.email;
    curUser.phone = response.user.phone;
    curUser.countryCode = response.user.countryCode;
    curUser.dialCode = response.user.dialCode;
    curUser.gender = response.user.gender;
    curUser.description = response.user.description;
    curUser.title = response.user.title;
    curUser.birthDate = response.user.birthDate;
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
      response = await client.updatePassword(updatePasswordRequest,
          options: callOptions);
    } catch (e) {
      throw GrpcError;
    }
    curUser = response.user;
    return response;
  }

  Future<userService.AuthHistory> getCurrentUserAuthHistory() async {
    userService.AuthHistory authHistory = userService.AuthHistory();

    try {
      var metadata = {"token": token.token};
      CallOptions callOptions = CallOptions(metadata: metadata);
      authHistory = await client.getAuthHistory(userService.Request(),
          options: callOptions);
    } catch (e) {
      throw GrpcError;
    }
    return authHistory;
  }

  Future<userService.Token> blockTokenByID(String tokenID) async {
    userService.Token responseToken = userService.Token();

    try {
      var metadata = {"token": token.token};
      CallOptions callOptions = CallOptions(metadata: metadata);
      userService.BlockTokenRequest request = userService.BlockTokenRequest()
        ..tokenID = tokenID;
      responseToken =
          await client.blockTokenByID(request, options: callOptions);
    } catch (e) {
      throw GrpcError;
    }
    return responseToken;
  }

  Future<userService.Response> blockAllUsersTokens() async {
    userService.Response response = userService.Response();

    try {
      var metadata = {"token": token.token};
      CallOptions callOptions = CallOptions(metadata: metadata);
      response = await client.blockUsersTokens(userService.Request(),
          options: callOptions);
      token.clearToken();
      onLogout();
    } catch (e) {
      throw GrpcError;
    }
    return response;
  }

  Future<userService.Response> deleteUser(String id) async {
    userService.Response response = userService.Response();

    try {
      var metadata = {"token": token.token};
      CallOptions callOptions = CallOptions(metadata: metadata);
      response = await client.delete(userService.User()..id = id,
          options: callOptions);
    } catch (e) {
      throw GrpcError;
    }
    return response;
  }

  Future<userService.Token> generateSignupToken(
    bool allowView,
    bool allowCreate,
    bool allowPermission,
    bool allowDelete,
    bool allowBlock,
  ) async {
    userService.Token tokenResponse = userService.Token();
    try {
      var metadata = {"token": token.token};
      userService.User user = userService.User()
        ..allowView = allowView
        ..allowCreate = allowCreate
        ..allowPermission = allowPermission
        ..allowDelete = allowDelete
        ..allowBlock = allowBlock;
      CallOptions callOptions = CallOptions(metadata: metadata);
      tokenResponse =
          await client.generateSignupToken(user, options: callOptions);
    } catch (e) {
      throw GrpcError;
    }
    return tokenResponse;
  }

  Future<userService.Response> signupByToken(String name, String email,
      String password, bool gender, String signupToken) async {
    userService.Response response = userService.Response();

    try {
      var metadata = {"token": signupToken};
      userService.User user = userService.User()
        ..name = name
        ..email = email
        ..password = password
        ..gender = gender;
      CallOptions callOptions = CallOptions(metadata: metadata);
      response = await client.signup(user, options: callOptions);
    } catch (e) {
      throw GrpcError;
    }
    return response;
  }

  Future<userService.Token> logout() async {
    userService.Token resToken = userService.Token();
    try {
      var metadata = {"token": token.token};
      CallOptions callOptions = CallOptions(metadata: metadata);
      resToken = await client.blockToken(token, options: callOptions);
    } catch (e) {
      throw GrpcError;
    }
    token.clearToken();
    onLogout();
    return resToken;
  }

  Stream<userService.UploadImageRequest> generateUploadStream(
      Uint8List fileInBytes) async* {
    final tokenReq = userService.UploadImageRequest()..token = token.token;
    yield tokenReq;
    int size = 1024;
    for (var i = 0; i < fileInBytes.length; i += size) {
      final dataReq = userService.UploadImageRequest()
        ..chunkData = fileInBytes.sublist(
            i, i + size > fileInBytes.length ? fileInBytes.length : i + size);
      yield dataReq;
    }
  }

  Future<userService.Token> uploadUserImage() async {
    userService.Token resToken = userService.Token();
    // show a dialog to open a file
    try {
      FilePickerCross file = await FilePickerCross.importFromStorage(
        type: FileTypeCross
            .any, // Available: `any`, `audio`, `image`, `video`, `custom`. Note: not available using FDE
/*         fileExtension:
            '.jpeg, .jpg, .png' // Only if FileTypeCross.custom . May be any file extension like `.dot`, `.ppt,.pptx,.odp` */
      );

      Uint8List fileToBytes = file.toUint8List();

      await client.uploadImage(generateUploadStream(fileToBytes));
    } on FileSelectionCanceledError catch (e) {
      return null;
    }
    return resToken;
  }
}
