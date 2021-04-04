import 'package:flutter/cupertino.dart';

class ChatMessageImage {
  ChatMessageImage({
    //@required this.id,
    @required this.key,
    //@required this.messageId,
  });

  //int id;
  String key;
  //int messageId;

  factory ChatMessageImage.fromJson(Map<String, dynamic> json) => ChatMessageImage(
        //id: json["id"] == null ? null : json["id"],
        key: json["key"] == null ? null : json["key"],
        //messageId: json["message_id"] == null ? null : json["message_id"],
      );

  Map<String, dynamic> toJson() => {
        //"id": id == null ? null : id,
        "key": key == null ? null : key,
        //"message_id": messageId == null ? null : messageId,
      };
}
