import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:dart_hqs/hqs_user_service.pbgrpc.dart' as userService;
import 'package:dart_hqs/hqs_privilege_service.pbgrpc.dart' as privilegeService;
import 'package:grpc/grpc.dart';
import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:platform_info/platform_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HqsService {
  userService.Token curToken = userService.Token();
  userService.User curUser = userService.User();
  privilegeService.Privilege curPrivilege = privilegeService.Privilege();
  // user service
  userService.UserServiceClient userClient;
  final String userServiceAddr;
  final int userServicePort;

  // privilege service
  privilegeService.PrivilegeServiceClient privilegeClient;
  final String privilegeServiceAddr;
  final int privilegeServicePort;

  final Function onLogout;
  final Function onLogin;

  HqsService(
      {@required this.userServiceAddr,
      @required this.userServicePort,
      @required this.privilegeServiceAddr,
      @required this.privilegeServicePort,
      @required this.onLogin,
      @required this.onLogout}) {
    // assert not null
    assert(userServiceAddr != null);
    assert(userServicePort != null);
    assert(privilegeServiceAddr != null);
    assert(privilegeServicePort != null);
    assert(onLogin != null);
    assert(onLogout != null);
  }

  Future<void> connect() async {
    try {
      // create connection to userClient
      ClientChannel userClientChannel = new ClientChannel(userServiceAddr,
          port: userServicePort,
          options: ChannelOptions(credentials: ChannelCredentials.insecure()));
      userClient = userService.UserServiceClient(userClientChannel);
      userClient.ping(userService.Request());

      // craete conncetion to privilege client
      ClientChannel privilegeClientChannel = new ClientChannel(
          privilegeServiceAddr,
          port: privilegeServicePort,
          options: ChannelOptions(credentials: ChannelCredentials.insecure()));
      privilegeClient =
          privilegeService.PrivilegeServiceClient(privilegeClientChannel);
      privilegeClient.ping(privilegeService.Request());
      // check if we have a valid token
      await checkStoredToken();
    } catch (e) {
      throw e;
    }
    return;
  }

  // todo: create a service that checks if user has a stored token on startup
  Future<void> checkStoredToken() async {
    // check if user has a stored token and authenticate it
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String storedToken = prefs.getString("stored_token");
    if (storedToken == null || storedToken.isEmpty) return;
    userService.Token validateToken = await userClient
        .validateToken(userService.Token()..token = storedToken);
    if (validateToken.valid) {
      curToken.token = storedToken;
      await onLogin();
    }
    return;
  }

  // authenticate - login and returns a token
  Future<userService.Token> authenticate(
      BuildContext context, String email, String password) async {
    curToken.clearToken();
    userService.User authUser = userService.User()
      ..email = email
      ..password = password;

    // validate
    if (email.isEmpty || password.isEmpty) {
      return curToken;
    }

    // get longitude & latitude
    String latitude = "0.0";
    String longitude = "0.0";

    // get device info
    String deviceInfo = "";
    try {
      switch (Platform.I.operatingSystem) {
        case OperatingSystem.macOS:
          deviceInfo = "macOS";
          break;
        case OperatingSystem.iOS:
          deviceInfo = "iOS";
          break;
        case OperatingSystem.android:
          deviceInfo = "Android";
          break;
        case OperatingSystem.linux:
          deviceInfo = "Linux";
          break;
        case OperatingSystem.windows:
          deviceInfo = "Windows";
          break;
        default:
          deviceInfo = "Unknown";
          break;
      }
    } catch (e) {
      print("Could not get device info");
    }
    var metadata = {
      "latitude": "0.0",
      "longitude": "0.0",
      "device": deviceInfo,
    };

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      CallOptions callOptions = CallOptions(metadata: metadata);
      curToken =
          await userClient.auth(authUser, options: callOptions).then((val) {
        prefs.setString('stored_token', val.token);
        return val;
      });

      getCurrentUser();
    } on GrpcError catch (e) {
      throw e;
    } catch (e) {
      throw e;
    }
    return curToken;
  }

  Future<privilegeService.Response> getCurrentPrivileges() async {
    privilegeService.Response response = privilegeService.Response();
    try {
      response = await privilegeClient
          .get(privilegeService.Privilege()..id = curUser.privilegeID);
    } catch (e) {
      curPrivilege.clear();
      throw e;
    }
    curPrivilege = response.privilege;
    return response;
  }

  Future<privilegeService.Response> deletePrivilege(
      privilegeService.Privilege privilege) async {
    privilegeService.Response response = privilegeService.Response();
    try {
      var metadata = {"token": curToken.token};
      CallOptions callOptions = CallOptions(metadata: metadata);
      response = await privilegeClient.delete(privilege, options: callOptions);
    } catch (e) {
      curPrivilege.clear();
      throw e;
    }
    return response;
  }

  Future<privilegeService.Response> newPrivilege(
      privilegeService.Privilege privilege) async {
    privilegeService.Response response = privilegeService.Response();
    try {
      var metadata = {"token": curToken.token};
      CallOptions callOptions = CallOptions(metadata: metadata);
      response = await privilegeClient.create(privilege, options: callOptions);
    } catch (e) {
      curPrivilege.clear();
      throw e;
    }
    return response;
  }

  Future<privilegeService.Response> updatePrivilege(
      privilegeService.Privilege privilege) async {
    privilegeService.Response response = privilegeService.Response();
    try {
      var metadata = {"token": curToken.token};
      CallOptions callOptions = CallOptions(metadata: metadata);
      response = await privilegeClient.update(privilege, options: callOptions);
    } catch (e) {
      curPrivilege.clear();
      throw e;
    }
    return response;
  }

  Future<privilegeService.Response> getAllPrivileges() async {
    privilegeService.Response response = privilegeService.Response();
    try {
      response = await privilegeClient.getAll(privilegeService.Request());
    } catch (e) {
      throw e;
    }
    return response;
  }

  // get current user by users token - if a error is present, log that user out
  Future<userService.Response> getCurrentUser() async {
    userService.Response response = userService.Response();
    try {
      var metadata = {"token": curToken.token};
      CallOptions callOptions = CallOptions(metadata: metadata);
      response = await userClient.getByToken(userService.Request(),
          options: callOptions);
      curUser = response.user;
      await getCurrentPrivileges();
    } catch (e) {
      print("we get in here!!");
      print(e.toString());
      curToken.clearToken();
      onLogout();
    }
    return response;
  }

  // get all users - get all users tokens
  Future<userService.Response> getAllUsers() async {
    userService.Response response = userService.Response();
    // check if user is allowed
    if (!curPrivilege.viewAllUsers) {
      return response;
    }
    try {
      var metadata = {"token": curToken.token};
      CallOptions callOptions = CallOptions(metadata: metadata);
      response = await userClient
          .getAll(userService.Request(), options: callOptions)
          .then((rep) {
        return rep;
      });
    } catch (e) {
      curToken.clearToken();
      onLogout();
    }
    return response;
  }

  // get logged users auth history
  Future<userService.AuthHistory> getCurrentUserAuthHistory() async {
    userService.AuthHistory authHistory = userService.AuthHistory();
    try {
      var metadata = {"token": curToken.token};
      CallOptions callOptions = CallOptions(metadata: metadata);
      authHistory = await userClient.getAuthHistory(userService.Request(),
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
      String name, String email, String password, bool gender) async {
    userService.Response response = userService.Response();
    if (!curPrivilege.createUser) {
      return response;
    }
    try {
      var metadata = {"token": curToken.token};
      CallOptions callOptions = CallOptions(metadata: metadata);
      response = await userClient
          .create(
              userService.User()
                ..name = name
                ..email = email
                ..password = password
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
    if (!curPrivilege.blockUser) {
      return response;
    }
    try {
      var metadata = {"token": curToken.token};
      CallOptions callOptions = CallOptions(metadata: metadata);
      response = await userClient
          .updateBlockUser(
              userService.User()
                ..blocked = !user.blocked
                ..id = user.id,
              options: callOptions)
          .then((rep) {
        return rep;
      });
    } catch (e) {
      curToken.clearToken();
      onLogout();
      throw e;
    }
    return response;
  }

  // update a users permissions - only if you have access
  Future<userService.Response> updateUsersPrivileges(
    String userId,
    String privilegeId,
  ) async {
    userService.Response response = userService.Response();
    if (!curPrivilege.managePrivileges) {
      return response;
    }
    try {
      var metadata = {"token": curToken.token};
      CallOptions callOptions = CallOptions(metadata: metadata);
      response = await userClient
          .updatePrivileges(
              userService.User()
                ..id = userId
                ..privilegeID = privilegeId,
              options: callOptions)
          .then((rep) {
        getCurrentUser();
        return rep;
      });
    } catch (e) {
      curToken.clearToken();
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
    if (curToken == null || curToken.token.isEmpty) {
      curToken.clearToken();
      // logout or maybe authenticate again...
    }
    try {
      var metadata = {"token": curToken.token};

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
      response = await userClient.updateProfile(user, options: callOptions);
    } catch (e) {
      curToken.clearToken();
      onLogout();
      throw e;
    }
    await getCurrentUser();
    return response;
  }

  // update currents users password.
  Future<userService.Response> updateCurrentUserPassword(
    BuildContext context,
    String oldPassword,
    String newPassword,
  ) async {
    userService.Response response = userService.Response();
    if (curToken == null || curToken.token.isEmpty) {
      curToken.clearToken();
      // logout or maybe authenticate again...
    }
    try {
      var metadata = {"token": curToken.token};
      CallOptions callOptions = CallOptions(metadata: metadata);
      userService.UpdatePasswordRequest updatePasswordRequest =
          userService.UpdatePasswordRequest()
            ..oldPassword = oldPassword
            ..newPassword = newPassword;
      response = await userClient.updatePassword(updatePasswordRequest,
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
      var metadata = {"token": curToken.token};
      CallOptions callOptions = CallOptions(metadata: metadata);
      userService.BlockTokenRequest request = userService.BlockTokenRequest()
        ..tokenID = tokenID;
      responseToken =
          await userClient.blockTokenByID(request, options: callOptions);
    } catch (e) {
      curToken.clearToken();
      onLogout();
      throw e;
    }
    return responseToken;
  }

  // block all of your tokens.
  Future<userService.Response> blockAllUsersTokens() async {
    userService.Response response = userService.Response();

    try {
      var metadata = {"token": curToken.token};
      CallOptions callOptions = CallOptions(metadata: metadata);
      response = await userClient.blockUsersTokens(userService.Request(),
          options: callOptions);
      curToken.clearToken();
      onLogout();
    } catch (e) {
      curToken.clearToken();
      onLogout();
      throw e;
    }
    return response;
  }

  // delete a user if you have access.
  Future<userService.Response> deleteUser(String id) async {
    userService.Response response = userService.Response();
    if (!curPrivilege.deleteUser) {
      return response;
    }
    try {
      var metadata = {"token": curToken.token};
      CallOptions callOptions = CallOptions(metadata: metadata);
      response = await userClient.delete(userService.User()..id = id,
          options: callOptions);
    } catch (e) {
      curToken.clearToken();
      onLogout();
      throw e;
    }
    return response;
  }

  // generate a token another user can use to signup with
  Future<userService.Token> generateSignupToken() async {
    userService.Token tokenResponse = userService.Token();
    if (!curPrivilege.createUser) {
      return tokenResponse;
    }
    try {
      var metadata = {"token": curToken.token};
      userService.User user = userService.User();
      CallOptions callOptions = CallOptions(metadata: metadata);
      tokenResponse =
          await userClient.generateSignupToken(user, options: callOptions);
    } catch (e) {
      curToken.clearToken();
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
      response = await userClient.signup(user, options: callOptions);
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
      var metadata = {"token": curToken.token};
      CallOptions callOptions = CallOptions(metadata: metadata);
      response =
          await userClient.emailResetPasswordToken(user, options: callOptions);
    } catch (e) {
      throw e;
    }
    return response;
  }

  Future<userService.Token> logout() async {
    userService.Token resToken = userService.Token();
    try {
      var metadata = {"token": curToken.token};
      CallOptions callOptions = CallOptions(metadata: metadata);
      resToken = await userClient.blockToken(curToken, options: callOptions);
    } catch (e) {
      throw e;
    }
    curToken.clearToken();
    onLogout();
    return resToken;
  }

  Stream<userService.UploadImageRequest> generateUploadStream(
      Uint8List fileInBytes) async* {
    final tokenReq = userService.UploadImageRequest()..token = curToken.token;
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

      await userClient
          .uploadImage(generateUploadStream(fileToBytes))
          .then((resp) {
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
