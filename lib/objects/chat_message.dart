import 'package:messager/objects/chat_message_image.dart';
import 'package:messager/objects/profile.dart';

class ChatMessage {
  int id;
  int userId;
  int roomId;
  String uuid;
  String cryptedMessage;
  String encryptedMessage;
  DateTime date;
  Profile sender;
  List<ChatMessageImage> photos;
  List<ChatMessageDocument> files;
  bool isSended;

  ChatMessage(
      {this.id,
      this.userId,
      this.roomId,
      this.uuid,
      this.cryptedMessage,
      this.encryptedMessage,
      this.date,
      this.sender,
      this.isSended = true,
      this.photos,
      this.files});

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
        id: json["id"],
        userId: json["user_id"],
        roomId: json["room_id"],
        uuid: json["uuid"],
        encryptedMessage: json["encryptedMessage"],
        cryptedMessage: json["text"],
        date: DateTime.fromMillisecondsSinceEpoch(json["date"] * 1000),
        photos: json["photos"] == null
            ? []
            : List<ChatMessageImage>.from(json["photos"].map((x) => ChatMessageImage.fromJson(x))),
        files: json["documents"] == null
            ? []
            : List<ChatMessageDocument>.from(
                json["documents"].map((x) => ChatMessageDocument.fromJson(x))),
        sender: json["user"] != null
            ? Profile.fromJson(json["user"])
            : Profile.fromJson(json["sender"]),
        isSended: json["is_sended"] == null ? true : json["is_sended"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "room_id": roomId,
        "uuid": uuid,
        "encryptedMessage": encryptedMessage,
        "text": cryptedMessage,
        "date": date.millisecondsSinceEpoch ~/ 1000,
        "user": sender.toJson(),
        "is_sended": isSended,
        "photos": photos == null ? null : List<dynamic>.from(photos.map((x) => x.toJson())),
        "documents": files == null ? null : List<dynamic>.from(files.map((x) => x.toJson())),
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatMessage && runtimeType == other.runtimeType && uuid == other.uuid;

  @override
  int get hashCode => uuid.hashCode;
}
