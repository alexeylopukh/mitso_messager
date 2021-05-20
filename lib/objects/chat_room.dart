import 'package:flutter/material.dart';
import 'package:messager/objects/chat_message.dart';
import 'package:messager/objects/profile.dart';

class ChatRoom {
  int id;
  String name;
  String imageKey;
  List<ChatMessage> messages;
  Profile user;
  bool isDirect;

  ChatRoom(
      {@required this.id,
      @required this.name,
      @required this.imageKey,
      @required this.messages,
      @required this.isDirect,
      @required this.user}) {
    if (user != null) {
      name = user.name;
      imageKey = user.avatarUrl;
    }
  }

  factory ChatRoom.fromJson(Map<String, dynamic> json) => ChatRoom(
      id: json["id"],
      name: json["room_name"],
      messages: json["messages"] != null && json["messages"] is List && json["messages"].isNotEmpty
          ? List<ChatMessage>.from(json["messages"].map((x) => ChatMessage.fromJson(x)))
          : [],
      imageKey:
          json["thumb_key"] != null && json["thumb_key"] is String && json["thumb_key"].isNotEmpty
              ? json["thumb_key"]
              : null,
      isDirect: json["is_direct"] == true,
      user: json["user"] != null && json["is_direct"] == true
          ? Profile.fromJson(json["user"])
          : null);

  Map<String, dynamic> toJson() => {
        "id": id,
        "room_name": name,
        "messages": List<dynamic>.from(messages.map((x) => x.toJson())),
        "thumb_key": imageKey,
        "is_direct": isDirect,
        "user": user == null ? null : user.toJson(),
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatRoom && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
