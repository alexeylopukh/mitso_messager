import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:messager/constants.dart';
import 'package:messager/presentation/di/user_scope_data.dart';

class ChatKeysCloudStore {
  final UserScopeData userScope;

  ChatKeysCloudStore(this.userScope);

  Future<Map<int, String>> getKeys() async {
    var body = {
      'token': userScope.authToken(),
    };

    final response = await http
        .post(Uri.parse(API_URL + '/api/get_private_keys'), body: jsonEncode(body))
        .timeout(Duration(seconds: 10), onTimeout: () {
      throw ChatKeysCloudStoreException(code: ChatKeysCloudStoreExceptionCode.Timeout);
    }).catchError((e) {
      throw ChatKeysCloudStoreException(code: ChatKeysCloudStoreExceptionCode.CommunicationError);
    });

    if (response.statusCode == 200) {
      List<ChatKeysCloudStoreResponse> roomsKeys =
          chatKeysCloudStoreResponseFromJson(response.body);

      Map<int, String> keys = {};
      roomsKeys.forEach((element) {
        keys[element.id] = element.privateKey;
      });
      return keys;
    }
    throw ChatKeysCloudStoreException(code: ChatKeysCloudStoreExceptionCode.InternalError);
  }
}

List<ChatKeysCloudStoreResponse> chatKeysCloudStoreResponseFromJson(String str) =>
    List<ChatKeysCloudStoreResponse>.from(
        json.decode(str).map((x) => ChatKeysCloudStoreResponse.fromJson(x)));

String chatKeysCloudStoreResponseToJson(List<ChatKeysCloudStoreResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ChatKeysCloudStoreResponse {
  ChatKeysCloudStoreResponse({
    @required this.id,
    @required this.privateKey,
  });

  int id;
  String privateKey;

  factory ChatKeysCloudStoreResponse.fromJson(Map<String, dynamic> json) =>
      ChatKeysCloudStoreResponse(
        id: json["id"],
        privateKey: json["private_key"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "private_key": privateKey,
      };
}

enum ChatKeysCloudStoreExceptionCode { InternalError, CommunicationError, Timeout }

class ChatKeysCloudStoreException implements Exception {
  ChatKeysCloudStoreExceptionCode code;
  String message;

  ChatKeysCloudStoreException({@required this.code}) {
    switch (code) {
      case ChatKeysCloudStoreExceptionCode.InternalError:
        message = INTERNAL_ERROR_MESSAGE;
        break;
      case ChatKeysCloudStoreExceptionCode.CommunicationError:
        message = COMMUNICATION_ERROR_MESSAGE;
        break;
      case ChatKeysCloudStoreExceptionCode.Timeout:
        message = TIMEOUT_ERROR_MESSAGE;
        break;
    }
  }
}
