import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:messager/constants.dart';
import 'package:messager/presentation/di/user_scope_data.dart';
import 'package:path/path.dart' as path;

class UploadImageRpc {
  final UserScopeData userScope;

  UploadImageRpc(this.userScope);

  Future<String> upload(
    File file, {
    StreamController uploadProgressStreamController,
    String roomId,
    int isMessage,
  }) async {
    final fileByteStream = http.ByteStream(Stream.castFrom(file.openRead()));
    final length = file.lengthSync();
    final uri = Uri.parse(API_URL + '/api/upload_photo');

    int byteCount = 0;

    Stream<List<int>> uploadProgressStream =
        fileByteStream.transform(StreamTransformer.fromHandlers(
            handleData: (data, sink) {
              byteCount += data.length;
              uploadProgressStreamController?.add(byteCount / length);
              sink.add(data);
            },
            handleError: (error, stack, sink) {},
            handleDone: (sink) {
              sink.close();
            }));

    final request = http.MultipartRequest("POST", uri);
    request.fields['token'] = await userScope.authToken();
    if (isMessage != null) request.fields['is_message'] = "1";
    if (roomId != null) request.fields['room_id'] = roomId;
    final multipartFile = http.MultipartFile('file_name', uploadProgressStream, length,
        filename: path.basename(file.path));

    request.files.add(multipartFile);

    var response = await request.send().catchError((e) {
      throw UploadImageRpcException(code: UploadImageRpcExceptionCode.CommunicationError);
    });

    if (response.statusCode == 200) {
      String json = await response.stream.bytesToString();
      var parsedJson = jsonDecode(json);
      if (parsedJson['image_key'] != null) return parsedJson['image_key'];
    }
    throw UploadImageRpcException(code: UploadImageRpcExceptionCode.InternalError);
  }
}

enum UploadImageRpcExceptionCode { InternalError, CommunicationError, Timeout }

class UploadImageRpcException implements Exception {
  UploadImageRpcExceptionCode code;
  String message;

  UploadImageRpcException({@required this.code}) {
    switch (code) {
      case UploadImageRpcExceptionCode.InternalError:
        message = INTERNAL_ERROR_MESSAGE;
        break;
      case UploadImageRpcExceptionCode.CommunicationError:
        message = COMMUNICATION_ERROR_MESSAGE;
        break;
      case UploadImageRpcExceptionCode.Timeout:
        message = TIMEOUT_ERROR_MESSAGE;
        break;
    }
  }
}
