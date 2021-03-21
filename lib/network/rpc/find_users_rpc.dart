import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:messager/constants.dart';
import 'package:messager/objects/profile.dart';
import 'package:messager/presentation/di/user_scope_data.dart';

class FindUsersRpc {
  final UserScopeData userScope;

  FindUsersRpc(this.userScope);

  Future<List<Profile>> getProfiles(String name) async {
    var body = {
      'token': userScope.authToken(),
      'query': name,
    };

    final response = await http
        .post(Uri.parse(API_URL + '/api/find_user'), body: jsonEncode(body))
        .timeout(Duration(seconds: 10), onTimeout: () {
      throw FindUsersRpcException(code: FindUsersRpcExceptionCode.Timeout);
    }).catchError((e) {
      throw FindUsersRpcException(code: FindUsersRpcExceptionCode.CommunicationError);
    });

    if (response.statusCode == 200) {
      if (response.body == 'null\n') return [];
      print("response: ${response.body} \n is null: ${response.body == null}");
      List<Profile> profiles =
          List<Profile>.from(json.decode(response.body).map((x) => Profile.fromJson(x)));
      return profiles;
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
