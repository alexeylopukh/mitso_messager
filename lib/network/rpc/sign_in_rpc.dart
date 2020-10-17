import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:messager/constants.dart';
import 'package:messager/objects/profile.dart';

class SignInRpc {
  Future<SignInRpcResponse> signIn(String email, String pass) async {
    var body = {
      'email': email,
      'password': pass,
    };

    final response = await http
        .post(API_URL + '/api/auth', body: jsonEncode(body))
        .timeout(Duration(seconds: 10), onTimeout: () {
      throw SignInRpcException(code: SignInRpcExceptionCode.Timeout);
    }).catchError((e) {
      throw SignInRpcException(code: SignInRpcExceptionCode.CommunicationError);
    });

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final parsedResponse = SignInRpcResponse.fromJson(decoded);
      if (parsedResponse.token != null) {
        return parsedResponse;
      }
    } else if (response.statusCode == 401)
      throw SignInRpcException(code: SignInRpcExceptionCode.InvalidEmailOrPassword);
    else
      throw SignInRpcException(code: SignInRpcExceptionCode.InternalError);
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

enum SignInRpcExceptionCode { InternalError, CommunicationError, Timeout, InvalidEmailOrPassword }

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
      case SignInRpcExceptionCode.InvalidEmailOrPassword:
        message = "Неправильный логин или пароль";
        break;
    }
  }
}
