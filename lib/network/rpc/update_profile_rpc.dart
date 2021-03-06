import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:messager/constants.dart';
import 'package:messager/objects/profile.dart';
import 'package:messager/presentation/di/user_scope_data.dart';

class UpdateProfileRpc {
  final UserScopeData userScope;

  UpdateProfileRpc(this.userScope);

  Future<bool> update({String imageKey}) async {
    var body = {
      'image_key': imageKey,
      'token': await userScope.authToken(),
    };

    final response = await http
        .post(Uri.parse(API_URL + '/api/update_user'), body: jsonEncode(body))
        .timeout(Duration(seconds: 10), onTimeout: () {
      throw SignInRpcException(code: SignInRpcExceptionCode.Timeout);
    }).catchError((e) {
      throw SignInRpcException(code: SignInRpcExceptionCode.CommunicationError);
    });

    if (response.statusCode == 200) {
      return true;
    }
    throw SignInRpcException(code: SignInRpcExceptionCode.InternalError);
  }
}

class SignInRpcResponse {
  String token;
  Profile profile;

  SignInRpcResponse({
    this.token,
    this.profile,
  });

  factory SignInRpcResponse.fromJson(Map<String, dynamic> json) => SignInRpcResponse(
        token: json["token"],
        profile: Profile.fromJson(json["profile"]),
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "profile": profile.toJson(),
      };
}

enum SignInRpcExceptionCode { InternalError, CommunicationError, Timeout }

class SignInRpcException implements Exception {
  SignInRpcExceptionCode code;
  String message;

  SignInRpcException({@required this.code}) {
    switch (code) {
      case SignInRpcExceptionCode.InternalError:
        message = INTERNAL_ERROR_MESSAGE;
        break;
      case SignInRpcExceptionCode.CommunicationError:
        message = COMMUNICATION_ERROR_MESSAGE;
        break;
      case SignInRpcExceptionCode.Timeout:
        message = TIMEOUT_ERROR_MESSAGE;
        break;
    }
  }
}
