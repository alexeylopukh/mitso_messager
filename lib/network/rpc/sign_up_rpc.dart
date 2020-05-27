import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:messager/constants.dart';
import 'package:messager/objects/profile.dart';

class SignUpRpc {
  Future<SignUpRpcResponse> signUp(
      String email, String pass, String name) async {
    var body = {'email': email, 'password': pass, 'name': name};

    final response = await http
        .post(API_URL + '/api/register', body: jsonEncode(body))
        .timeout(Duration(seconds: 10), onTimeout: () {
      throw SignUpRpcException(code: SignUpRpcExceptionCode.Timeout);
    }).catchError((e) {
      throw SignUpRpcException(code: SignUpRpcExceptionCode.CommunicationError);
    });

    if (response.statusCode == 201) {
      final decoded = json.decode(response.body);
      final parsedResponse = SignUpRpcResponse.fromJson(decoded);
      if (parsedResponse.token != null) {
        return parsedResponse;
      }
    } else
      throw SignUpRpcException(code: SignUpRpcExceptionCode.InternalError);
    throw SignUpRpcException(code: SignUpRpcExceptionCode.InternalError);
  }
}

class SignUpRpcResponse {
  String token;
  Profile profile;

  SignUpRpcResponse({
    this.token,
    this.profile,
  });

  factory SignUpRpcResponse.fromJson(Map<String, dynamic> json) =>
      SignUpRpcResponse(
        token: json["token"],
        profile: Profile.fromJson(json["profile"]),
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "profile": profile.toJson(),
      };
}

enum SignUpRpcExceptionCode { InternalError, CommunicationError, Timeout }

class SignUpRpcException implements Exception {
  SignUpRpcExceptionCode code;
  String message;

  SignUpRpcException({@required this.code}) {
    switch (code) {
      case SignUpRpcExceptionCode.InternalError:
        message = INTERNAL_ERROR_MESSAGE;
        break;
      case SignUpRpcExceptionCode.CommunicationError:
        message = COMMUNICATION_ERROR_MESSAGE;
        break;
      case SignUpRpcExceptionCode.Timeout:
        message = TIMEOUT_ERROR_MESSAGE;
        break;
    }
  }
}
