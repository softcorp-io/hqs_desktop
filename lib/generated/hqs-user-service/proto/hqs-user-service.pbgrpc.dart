///
//  Generated code. Do not modify.
//  source: hqs-user-service/proto/hqs-user-service.proto
//
// @dart = 2.3
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:async' as $async;

import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'hqs-user-service.pb.dart' as $0;
export 'hqs-user-service.pb.dart';

class UserServiceClient extends $grpc.Client {
  static final _$create = $grpc.ClientMethod<$0.User, $0.Response>(
      '/UserService.UserService/Create',
      ($0.User value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Response.fromBuffer(value));
  static final _$generateSignupToken = $grpc.ClientMethod<$0.User, $0.Token>(
      '/UserService.UserService/GenerateSignupToken',
      ($0.User value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Token.fromBuffer(value));
  static final _$signup = $grpc.ClientMethod<$0.User, $0.Response>(
      '/UserService.UserService/Signup',
      ($0.User value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Response.fromBuffer(value));
  static final _$get = $grpc.ClientMethod<$0.User, $0.Response>(
      '/UserService.UserService/Get',
      ($0.User value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Response.fromBuffer(value));
  static final _$getByToken = $grpc.ClientMethod<$0.Request, $0.Response>(
      '/UserService.UserService/GetByToken',
      ($0.Request value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Response.fromBuffer(value));
  static final _$getByEmail = $grpc.ClientMethod<$0.User, $0.Response>(
      '/UserService.UserService/GetByEmail',
      ($0.User value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Response.fromBuffer(value));
  static final _$getAll = $grpc.ClientMethod<$0.Request, $0.Response>(
      '/UserService.UserService/GetAll',
      ($0.Request value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Response.fromBuffer(value));
  static final _$delete = $grpc.ClientMethod<$0.User, $0.Response>(
      '/UserService.UserService/Delete',
      ($0.User value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Response.fromBuffer(value));
  static final _$updateProfile = $grpc.ClientMethod<$0.User, $0.Response>(
      '/UserService.UserService/UpdateProfile',
      ($0.User value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Response.fromBuffer(value));
  static final _$updateAllowances = $grpc.ClientMethod<$0.User, $0.Response>(
      '/UserService.UserService/UpdateAllowances',
      ($0.User value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Response.fromBuffer(value));
  static final _$updatePassword =
      $grpc.ClientMethod<$0.UpdatePasswordRequest, $0.Response>(
          '/UserService.UserService/UpdatePassword',
          ($0.UpdatePasswordRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $0.Response.fromBuffer(value));
  static final _$updateBlockUser = $grpc.ClientMethod<$0.User, $0.Response>(
      '/UserService.UserService/UpdateBlockUser',
      ($0.User value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Response.fromBuffer(value));
  static final _$auth = $grpc.ClientMethod<$0.User, $0.Token>(
      '/UserService.UserService/Auth',
      ($0.User value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Token.fromBuffer(value));
  static final _$validateToken = $grpc.ClientMethod<$0.Token, $0.Token>(
      '/UserService.UserService/ValidateToken',
      ($0.Token value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Token.fromBuffer(value));
  static final _$blockToken = $grpc.ClientMethod<$0.Token, $0.Token>(
      '/UserService.UserService/BlockToken',
      ($0.Token value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Token.fromBuffer(value));
  static final _$blockTokenByID =
      $grpc.ClientMethod<$0.BlockTokenRequest, $0.Token>(
          '/UserService.UserService/BlockTokenByID',
          ($0.BlockTokenRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $0.Token.fromBuffer(value));
  static final _$blockUsersTokens = $grpc.ClientMethod<$0.Request, $0.Response>(
      '/UserService.UserService/BlockUsersTokens',
      ($0.Request value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Response.fromBuffer(value));
  static final _$getAuthHistory =
      $grpc.ClientMethod<$0.Request, $0.AuthHistory>(
          '/UserService.UserService/GetAuthHistory',
          ($0.Request value) => value.writeToBuffer(),
          ($core.List<$core.int> value) => $0.AuthHistory.fromBuffer(value));
  static final _$uploadImage =
      $grpc.ClientMethod<$0.UploadImageRequest, $0.UploadImageResponse>(
          '/UserService.UserService/UploadImage',
          ($0.UploadImageRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.UploadImageResponse.fromBuffer(value));

  UserServiceClient($grpc.ClientChannel channel, {$grpc.CallOptions options})
      : super(channel, options: options);

  $grpc.ResponseFuture<$0.Response> create($0.User request,
      {$grpc.CallOptions options}) {
    final call = $createCall(_$create, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<$0.Token> generateSignupToken($0.User request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$generateSignupToken, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<$0.Response> signup($0.User request,
      {$grpc.CallOptions options}) {
    final call = $createCall(_$signup, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<$0.Response> get($0.User request,
      {$grpc.CallOptions options}) {
    final call = $createCall(_$get, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<$0.Response> getByToken($0.Request request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$getByToken, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<$0.Response> getByEmail($0.User request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$getByEmail, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<$0.Response> getAll($0.Request request,
      {$grpc.CallOptions options}) {
    final call = $createCall(_$getAll, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<$0.Response> delete($0.User request,
      {$grpc.CallOptions options}) {
    final call = $createCall(_$delete, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<$0.Response> updateProfile($0.User request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$updateProfile, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<$0.Response> updateAllowances($0.User request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$updateAllowances, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<$0.Response> updatePassword(
      $0.UpdatePasswordRequest request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$updatePassword, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<$0.Response> updateBlockUser($0.User request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$updateBlockUser, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<$0.Token> auth($0.User request,
      {$grpc.CallOptions options}) {
    final call = $createCall(_$auth, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<$0.Token> validateToken($0.Token request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$validateToken, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<$0.Token> blockToken($0.Token request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$blockToken, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<$0.Token> blockTokenByID($0.BlockTokenRequest request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$blockTokenByID, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<$0.Response> blockUsersTokens($0.Request request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$blockUsersTokens, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<$0.AuthHistory> getAuthHistory($0.Request request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$getAuthHistory, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<$0.UploadImageResponse> uploadImage(
      $async.Stream<$0.UploadImageRequest> request,
      {$grpc.CallOptions options}) {
    final call = $createCall(_$uploadImage, request, options: options);
    return $grpc.ResponseFuture(call);
  }
}

abstract class UserServiceBase extends $grpc.Service {
  $core.String get $name => 'UserService.UserService';

  UserServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.User, $0.Response>(
        'Create',
        create_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.User.fromBuffer(value),
        ($0.Response value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.User, $0.Token>(
        'GenerateSignupToken',
        generateSignupToken_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.User.fromBuffer(value),
        ($0.Token value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.User, $0.Response>(
        'Signup',
        signup_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.User.fromBuffer(value),
        ($0.Response value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.User, $0.Response>(
        'Get',
        get_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.User.fromBuffer(value),
        ($0.Response value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Request, $0.Response>(
        'GetByToken',
        getByToken_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Request.fromBuffer(value),
        ($0.Response value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.User, $0.Response>(
        'GetByEmail',
        getByEmail_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.User.fromBuffer(value),
        ($0.Response value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Request, $0.Response>(
        'GetAll',
        getAll_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Request.fromBuffer(value),
        ($0.Response value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.User, $0.Response>(
        'Delete',
        delete_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.User.fromBuffer(value),
        ($0.Response value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.User, $0.Response>(
        'UpdateProfile',
        updateProfile_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.User.fromBuffer(value),
        ($0.Response value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.User, $0.Response>(
        'UpdateAllowances',
        updateAllowances_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.User.fromBuffer(value),
        ($0.Response value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.UpdatePasswordRequest, $0.Response>(
        'UpdatePassword',
        updatePassword_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.UpdatePasswordRequest.fromBuffer(value),
        ($0.Response value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.User, $0.Response>(
        'UpdateBlockUser',
        updateBlockUser_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.User.fromBuffer(value),
        ($0.Response value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.User, $0.Token>(
        'Auth',
        auth_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.User.fromBuffer(value),
        ($0.Token value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Token, $0.Token>(
        'ValidateToken',
        validateToken_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Token.fromBuffer(value),
        ($0.Token value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Token, $0.Token>(
        'BlockToken',
        blockToken_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Token.fromBuffer(value),
        ($0.Token value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.BlockTokenRequest, $0.Token>(
        'BlockTokenByID',
        blockTokenByID_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.BlockTokenRequest.fromBuffer(value),
        ($0.Token value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Request, $0.Response>(
        'BlockUsersTokens',
        blockUsersTokens_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Request.fromBuffer(value),
        ($0.Response value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Request, $0.AuthHistory>(
        'GetAuthHistory',
        getAuthHistory_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Request.fromBuffer(value),
        ($0.AuthHistory value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.UploadImageRequest, $0.UploadImageResponse>(
            'UploadImage',
            uploadImage,
            true,
            false,
            ($core.List<$core.int> value) =>
                $0.UploadImageRequest.fromBuffer(value),
            ($0.UploadImageResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.Response> create_Pre(
      $grpc.ServiceCall call, $async.Future<$0.User> request) async {
    return create(call, await request);
  }

  $async.Future<$0.Token> generateSignupToken_Pre(
      $grpc.ServiceCall call, $async.Future<$0.User> request) async {
    return generateSignupToken(call, await request);
  }

  $async.Future<$0.Response> signup_Pre(
      $grpc.ServiceCall call, $async.Future<$0.User> request) async {
    return signup(call, await request);
  }

  $async.Future<$0.Response> get_Pre(
      $grpc.ServiceCall call, $async.Future<$0.User> request) async {
    return get(call, await request);
  }

  $async.Future<$0.Response> getByToken_Pre(
      $grpc.ServiceCall call, $async.Future<$0.Request> request) async {
    return getByToken(call, await request);
  }

  $async.Future<$0.Response> getByEmail_Pre(
      $grpc.ServiceCall call, $async.Future<$0.User> request) async {
    return getByEmail(call, await request);
  }

  $async.Future<$0.Response> getAll_Pre(
      $grpc.ServiceCall call, $async.Future<$0.Request> request) async {
    return getAll(call, await request);
  }

  $async.Future<$0.Response> delete_Pre(
      $grpc.ServiceCall call, $async.Future<$0.User> request) async {
    return delete(call, await request);
  }

  $async.Future<$0.Response> updateProfile_Pre(
      $grpc.ServiceCall call, $async.Future<$0.User> request) async {
    return updateProfile(call, await request);
  }

  $async.Future<$0.Response> updateAllowances_Pre(
      $grpc.ServiceCall call, $async.Future<$0.User> request) async {
    return updateAllowances(call, await request);
  }

  $async.Future<$0.Response> updatePassword_Pre($grpc.ServiceCall call,
      $async.Future<$0.UpdatePasswordRequest> request) async {
    return updatePassword(call, await request);
  }

  $async.Future<$0.Response> updateBlockUser_Pre(
      $grpc.ServiceCall call, $async.Future<$0.User> request) async {
    return updateBlockUser(call, await request);
  }

  $async.Future<$0.Token> auth_Pre(
      $grpc.ServiceCall call, $async.Future<$0.User> request) async {
    return auth(call, await request);
  }

  $async.Future<$0.Token> validateToken_Pre(
      $grpc.ServiceCall call, $async.Future<$0.Token> request) async {
    return validateToken(call, await request);
  }

  $async.Future<$0.Token> blockToken_Pre(
      $grpc.ServiceCall call, $async.Future<$0.Token> request) async {
    return blockToken(call, await request);
  }

  $async.Future<$0.Token> blockTokenByID_Pre($grpc.ServiceCall call,
      $async.Future<$0.BlockTokenRequest> request) async {
    return blockTokenByID(call, await request);
  }

  $async.Future<$0.Response> blockUsersTokens_Pre(
      $grpc.ServiceCall call, $async.Future<$0.Request> request) async {
    return blockUsersTokens(call, await request);
  }

  $async.Future<$0.AuthHistory> getAuthHistory_Pre(
      $grpc.ServiceCall call, $async.Future<$0.Request> request) async {
    return getAuthHistory(call, await request);
  }

  $async.Future<$0.Response> create($grpc.ServiceCall call, $0.User request);
  $async.Future<$0.Token> generateSignupToken(
      $grpc.ServiceCall call, $0.User request);
  $async.Future<$0.Response> signup($grpc.ServiceCall call, $0.User request);
  $async.Future<$0.Response> get($grpc.ServiceCall call, $0.User request);
  $async.Future<$0.Response> getByToken(
      $grpc.ServiceCall call, $0.Request request);
  $async.Future<$0.Response> getByEmail(
      $grpc.ServiceCall call, $0.User request);
  $async.Future<$0.Response> getAll($grpc.ServiceCall call, $0.Request request);
  $async.Future<$0.Response> delete($grpc.ServiceCall call, $0.User request);
  $async.Future<$0.Response> updateProfile(
      $grpc.ServiceCall call, $0.User request);
  $async.Future<$0.Response> updateAllowances(
      $grpc.ServiceCall call, $0.User request);
  $async.Future<$0.Response> updatePassword(
      $grpc.ServiceCall call, $0.UpdatePasswordRequest request);
  $async.Future<$0.Response> updateBlockUser(
      $grpc.ServiceCall call, $0.User request);
  $async.Future<$0.Token> auth($grpc.ServiceCall call, $0.User request);
  $async.Future<$0.Token> validateToken(
      $grpc.ServiceCall call, $0.Token request);
  $async.Future<$0.Token> blockToken($grpc.ServiceCall call, $0.Token request);
  $async.Future<$0.Token> blockTokenByID(
      $grpc.ServiceCall call, $0.BlockTokenRequest request);
  $async.Future<$0.Response> blockUsersTokens(
      $grpc.ServiceCall call, $0.Request request);
  $async.Future<$0.AuthHistory> getAuthHistory(
      $grpc.ServiceCall call, $0.Request request);
  $async.Future<$0.UploadImageResponse> uploadImage(
      $grpc.ServiceCall call, $async.Stream<$0.UploadImageRequest> request);
}
