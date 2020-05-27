import 'package:messager/objects/chat_message.dart';

class ChatRoom {
  int id;
  String name;
  String imageKey;
  List<ChatMessage> messages;

  ChatRoom({this.id, this.name, this.imageKey, this.messages});

  factory ChatRoom.fromJson(Map<String, dynamic> json) => ChatRoom(
      id: json["id"],
      name: json["room_name"],
      messages: json["messages"] != null &&
              json["messages"] is List &&
              json["messages"].isNotEmpty
          ? List<ChatMessage>.from(
              json["messages"].map((x) => ChatMessage.fromJson(x)))
          : [],
      imageKey: json["thumb_key"] != null &&
              json["thumb_key"] is String &&
              json["thumb_key"].isNotEmpty
          ? json["thumb_key"]
          : null);

  Map<String, dynamic> toJson() => {
        "id": id,
        "room_name": name,
        "messages": List<dynamic>.from(messages.map((x) => x.toJson())),
        "thumb_key": imageKey
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatRoom && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
