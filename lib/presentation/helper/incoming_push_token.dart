import 'dart:convert';

import 'package:messager/objects/call_request.dart';
import 'package:messager/objects/chat_message.dart';
import 'package:messager/objects/profile.dart';
import 'package:messager/presentation/di/user_scope_data.dart';

class IncomingPushHelper {
  handlePush(Map<String, dynamic> message, UserScopeData userScope) {
    if (message != null && message["agoraRoom"] != null) {
      userScope.incomingCallListener
          .add(CallRequest(message["agoraRoom"], Profile.fromJson(jsonDecode(message["user"]))));
    } else if (message != null && message['data'] != null && message['data']['message'] != null) {
      String data = message['data']['message'];
      final decoded = jsonDecode(data);
      final chatMessage = ChatMessage.fromJson(decoded);
      userScope.goToChatRoomStream.add(chatMessage.roomId);
    }
  }
}
