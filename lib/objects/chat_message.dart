import 'package:messager/objects/profile.dart';

class ChatMessage {
  int id;
  int userId;
  int roomId;
  String uuid;
  String text;
  DateTime date;
  Profile sender;
  bool isSended;

  ChatMessage(
      {this.id,
      this.userId,
      this.roomId,
      this.uuid,
      this.text,
      this.date,
      this.sender,
      this.isSended = true});

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
      id: json["id"],
      userId: json["user_id"],
      roomId: json["room_id"],
      uuid: json["uuid"],
      text: json["text"],
      date: DateTime.fromMillisecondsSinceEpoch(json["date"] * 1000),
      sender: json["user"] != null
          ? Profile.fromJson(json["user"])
          : Profile.fromJson(json["sender"]),
      isSended: json["is_sended"] == null ? true : json["is_sended"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "room_id": roomId,
        "uuid": uuid,
        "text": text,
        "date": date.millisecondsSinceEpoch ~/ 1000,
        "user": sender.toJson(),
        "is_sended": isSended,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatMessage &&
          runtimeType == other.runtimeType &&
          uuid == other.uuid;

  @override
  int get hashCode => uuid.hashCode;
}