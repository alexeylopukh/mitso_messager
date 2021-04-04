import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:messager/constants.dart';
import 'package:messager/presentation/di/user_scope_data.dart';

class GenerateAgoraToken {
  final UserScopeData userScope;

  GenerateAgoraToken(this.userScope);

  Future<String> generateToken(String channel) async {
    final response = await http
        .get(
      Uri.parse("https://mimessenger.herokuapp.com/access_token?channel=$channel&uid=${0}"),
    )
        .timeout(Duration(seconds: 30), onTimeout: () {
      throw FindUsersRpcException(code: FindUsersRpcExceptionCode.Timeout);
    }).catchError((e) {
      throw FindUsersRpcException(code: FindUsersRpcExceptionCode.CommunicationError);
    });

    if (response.statusCode == 200) {
      return jsonDecode(response.body)["token"];
    }
    throw FindUsersRpcException(code: FindUsersRpcExceptionCode.InternalError);
  }
}

enum FindUsersRpcExceptionCode { InternalError, CommunicationError, Timeout }

class FindUsersRpcException implements Exception {
  FindUsersRpcExceptionCode code;
  String message;

  FindUsersRpcException({@required this.code}) {
    switch (code) {
      case FindUsersRpcExceptionCode.InternalError:
        message = INTERNAL_ERROR_MESSAGE;
        break;
      case FindUsersRpcExceptionCode.CommunicationError:
        message = COMMUNICATION_ERROR_MESSAGE;
        break;
      case FindUsersRpcExceptionCode.Timeout:
        message = TIMEOUT_ERROR_MESSAGE;
        break;
    }
  }
}
