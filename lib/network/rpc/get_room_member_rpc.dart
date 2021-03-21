import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:messager/constants.dart';
import 'package:messager/objects/profile.dart';
import 'package:messager/presentation/di/user_scope_data.dart';

class GetRoomMembersRpc {
  final UserScopeData userScope;

  GetRoomMembersRpc(this.userScope);

  Future<List<Profile>> getMembers(int roomId) async {
    var body = {
      'token': userScope.authToken(),
      'room_id': roomId,
    };

    final response = await http
        .post(Uri.parse(API_URL + '/api/get_room_members'), body: jsonEncode(body))
        .timeout(Duration(seconds: 10), onTimeout: () {
      throw GetRoomMembersRpcException(code: GetRoomMembersRpcExceptionCode.Timeout);
    }).catchError((e) {
      throw GetRoomMembersRpcException(code: GetRoomMembersRpcExceptionCode.CommunicationError);
    });

    if (response.statusCode == 200) {
      if (response.body == 'null\n') return [];
      print("response: ${response.body} \n is null: ${response.body == null}");
      List<Profile> profiles =
          List<Profile>.from(json.decode(response.body).map((x) => Profile.fromJson(x)));
      return profiles;
    }
    throw GetRoomMembersRpcException(code: GetRoomMembersRpcExceptionCode.InternalError);
  }
}

enum GetRoomMembersRpcExceptionCode { InternalError, CommunicationError, Timeout }

class GetRoomMembersRpcException implements Exception {
  GetRoomMembersRpcExceptionCode code;
  String message;

  GetRoomMembersRpcException({@required this.code}) {
    switch (code) {
      case GetRoomMembersRpcExceptionCode.InternalError:
        message = INTERNAL_ERROR_MESSAGE;
        break;
      case GetRoomMembersRpcExceptionCode.CommunicationError:
        message = COMMUNICATION_ERROR_MESSAGE;
        break;
      case GetRoomMembersRpcExceptionCode.Timeout:
        message = TIMEOUT_ERROR_MESSAGE;
        break;
    }
  }
}
