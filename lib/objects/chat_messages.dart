import 'chat_message.dart';

class ChatMessages {
  List<ChatMessage> messages;

  ChatMessages({
    this.messages,
  });

  factory ChatMessages.fromJson(Map<String, dynamic> json) => ChatMessages(
        messages: List<ChatMessage>.from(
            json["messages"].map((x) => ChatMessage.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "messages": List<dynamic>.from(messages.map((x) => x.toJson())),
      };
}
