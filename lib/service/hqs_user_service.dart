import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:dart_hqs/hqs_user_service.pbgrpc.dart' as userService;
import 'package:dart_hqs/google/protobuf/timestamp.pbserver.dart';
import 'package:flutter/services.dart';
import 'package:grpc/grpc.dart';
import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:platform_info/platform_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HqsService {
  userService.UserServiceClient client;
  userService.Token token = userService.Token();
  userService.User curUser = userService.User();

  final String addr;
  final int port;
  final Function onLogout;
  final Function onLogin;

  HqsService(
      {@required this.addr,
      @required this.port,
      @required this.onLogin,
      @required this.onLogout}) {
    // assert not null
    assert(addr != null);
    assert(port != null);
    assert(onLogin != null);
    assert(onLogout != null);
  }

  Future<void> connect() async {
    try {
      // create connection to client
      ClientChannel clientChannel = new ClientChannel(addr,
          port: port,
          options: ChannelOptions(credentials: ChannelCredentials.insecure()));
      client = userService.UserServiceClient(clientChannel);
      client.ping(userService.Request());
    } catch (e) {
      print(e);
      print("could not connect");
      throw e;
    }
    print("success!");
    return;
  }

  // todo: create a service that checks if user has a stored token on startup
  checkStoredToken() async {
    // check if user has a stored token and authenticate it
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String storedToken = prefs.getString("stored_token") ?? "";
    if (storedToken.isEmpty) return;
    validateToken(storedToken).then((valToken) {
      if (valToken.valid) {
        onLogin();
      }
      return valToken;
    });
  }

  Future<userService.Token> validateToken(String token) async {
    userService.Token validateToken = userService.Token();
    validateToken..token = token;
    try {
      userService.Token repToken =
          await client.validateToken(validateToken).then((valToken) {
        return valToken;
      });
      validateToken = repToken;
    } on GrpcError catch (e) {
      throw e;
    } catch (e) {
      throw e;
    }
    return validateToken;
  }

  // authenticate - login and returns a token
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
    String latitude = "0.0";
    String longitude = "0.0";
    /*    try {
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
                latitude = _locationData.latitude.toString();
                longitude = _locationData.longitude.toString();
            }
          }
        }
      }
    } catch (e) {
      print(e);
    }  */

    // get device info
    String deviceInfo = "";
    try {
      deviceInfo = Platform.I.operatingSystem.toString();
    } catch (e) {
      print("Could not get device info");
    }
    var metadata = {
      "latitude": "0.0",
      "longitude": "0.0",
      "device": deviceInfo,
    };

    try {
      CallOptions callOptions = CallOptions(metadata: metadata);
      token = await client.auth(authUser, options: callOptions).then((val) {
        return val;
      });
      getCurrentUser();
    } on GrpcError catch (e) {
      throw e;
    } catch (e) {
      throw e;
    }
    return token;
  }

  // get current user by users token - if a error is present, log that user out
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
    } catch (e) {
      token.clearToken();
      onLogout();
    }
    curUser = response.user;
    return response;
  }

  // get all users - get all users tokens
  Future<userService.Response> getAllUsers() async {
    userService.Response response = userService.Response();
    // check if user is allowed
    if (!curUser.allowView) {
      return response;
    }
    try {
      var metadata = {"token": token.token};
      CallOptions callOptions = CallOptions(metadata: metadata);
      response = await client
          .getAll(userService.Request(), options: callOptions)
          .then((rep) {
        return rep;
      });
    } catch (e) {
      token.clearToken();
      onLogout();
    }
    return response;
  }

  // get logged users auth history
  Future<userService.AuthHistory> getCurrentUserAuthHistory() async {
    userService.AuthHistory authHistory = userService.AuthHistory();
    try {
      var metadata = {"token": token.token};
      CallOptions callOptions = CallOptions(metadata: metadata);
      authHistory = await client.getAuthHistory(userService.Request(),
          options: callOptions);
    } catch (e) {
      print(e);
      //token.clearToken();
      //onLogout();
      throw e;
    }
    return authHistory;
  }

  // create a user - only allowed if current user got admin status.
  Future<userService.Response> createUser(
      String name,
      String email,
      String password,
      bool allowView,
      bool allowCreate,
      bool allowPermission,
      bool allowDelete,
      bool allowBlock,
      bool allowReset,
      bool gender) async {
    userService.Response response = userService.Response();
    if (!curUser.allowCreate) {
      return response;
    }
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
                ..allowBlock = allowBlock
                ..allowResetPassword = allowReset
                ..gender = gender,
              options: callOptions)
          .then((rep) {
        return rep;
      });
    } catch (e) {
      throw e;
    }
    return response;
  }

  // block a user - only if you have access.
  Future<userService.Response> blockUser(userService.User user) async {
    userService.Response response = userService.Response();
    if (!curUser.allowBlock) {
      return response;
    }
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
    } catch (e) {
      token.clearToken();
      onLogout();
      throw e;
    }
    return response;
  }

  // update a users permissions - only if you have access
  Future<userService.Response> updateUsersPermissions(
    String id,
    bool allowView,
    bool allowCreate,
    bool allowPermissions,
    bool allowDelete,
    bool allowBlock,
    bool allowReset,
  ) async {
    userService.Response response = userService.Response();
    if (!curUser.allowPermission) {
      return response;
    }
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
                ..allowResetPassword = allowReset
                ..allowBlock = allowBlock,
              options: callOptions)
          .then((rep) {
        getCurrentUser();
        return rep;
      });
    } catch (e) {
      token.clearToken();
      onLogout();
      throw e;
    }
    return response;
  }

  // update current users profile.
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
      String birthday) async {
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
        ..birthday = birthday
        ..description = description;
      response =
          await client.updateProfile(user, options: callOptions).then((rep) {
        return rep;
      });
    } catch (e) {
      token.clearToken();
      onLogout();
      throw e;
    }
    curUser.name = response.user.name;
    curUser.email = response.user.email;
    curUser.phone = response.user.phone;
    curUser.countryCode = response.user.countryCode;
    curUser.dialCode = response.user.dialCode;
    curUser.gender = response.user.gender;
    curUser.description = response.user.description;
    curUser.title = response.user.title;
    curUser.birthday = response.user.birthday;
    return response;
  }

  // update currents users password.
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
      throw e;
    }
    return response;
  }

  // block a token by its id.
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
      token.clearToken();
      onLogout();
      throw e;
    }
    return responseToken;
  }

  // block all of your tokens.
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
      token.clearToken();
      onLogout();
      throw e;
    }
    return response;
  }

  // delete a user if you have access.
  Future<userService.Response> deleteUser(String id) async {
    userService.Response response = userService.Response();
    if (!curUser.allowDelete) {
      return response;
    }
    try {
      var metadata = {"token": token.token};
      CallOptions callOptions = CallOptions(metadata: metadata);
      response = await client.delete(userService.User()..id = id,
          options: callOptions);
    } catch (e) {
      token.clearToken();
      onLogout();
      throw e;
    }
    return response;
  }

  // generate a token another user can use to signup with
  Future<userService.Token> generateSignupToken(
    bool allowView,
    bool allowCreate,
    bool allowPermission,
    bool allowDelete,
    bool allowBlock,
    bool allowReset,
  ) async {
    userService.Token tokenResponse = userService.Token();
    if (!curUser.allowCreate) {
      return tokenResponse;
    }
    try {
      var metadata = {"token": token.token};
      userService.User user = userService.User()
        ..allowView = allowView
        ..allowCreate = allowCreate
        ..allowPermission = allowPermission
        ..allowDelete = allowDelete
        ..allowResetPassword = allowReset
        ..allowBlock = allowBlock;
      CallOptions callOptions = CallOptions(metadata: metadata);
      tokenResponse =
          await client.generateSignupToken(user, options: callOptions);
    } catch (e) {
      token.clearToken();
      onLogout();
      throw e;
    }
    return tokenResponse;
  }

  // signup by a signup token
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
      throw e;
    }
    return response;
  }

  // sends an email to a user with reset password information
  Future<userService.Response> sendResetPassordEmail(
      userService.User user) async {
    if (user.email.isEmpty || user.id.isEmpty) {
      throw userService.Error();
    }
    userService.Response response = userService.Response();
    try {
      var metadata = {"token": token.token};
      CallOptions callOptions = CallOptions(metadata: metadata);
      response =
          await client.emailResetPasswordToken(user, options: callOptions);
    } catch (e) {
      throw e;
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
      throw e;
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

  Future<userService.Token> uploadUserImage(
      Function showDialog, Function closeDialog, BuildContext context) async {
    userService.Token resToken = userService.Token();
    // show a dialog to open a file
    try {
      FilePickerCross file = await FilePickerCross.importFromStorage(
        type: FileTypeCross
            .any, // Available: `any`, `audio`, `image`, `video`, `custom`. Note: not available using FDE
/*         fileExtension:
            '.jpeg, .jpg, .png' // Only if FileTypeCross.custom . May be any file extension like `.dot`, `.ppt,.pptx,.odp` */
      );
      if (file != null) {
        showDialog(context);
      }
      Uint8List fileToBytes = file.toUint8List();

      await client.uploadImage(generateUploadStream(fileToBytes)).then((resp) {
        closeDialog();
        return resp;
      });
    } on FileSelectionCanceledError catch (e) {
      return null;
    }
    await getCurrentUser();
    return resToken;
  }
}
