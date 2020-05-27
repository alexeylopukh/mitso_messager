import 'package:messager/objects/chat_message.dart';
import 'package:messager/objects/chat_room.dart';

class ChatScreenViewModel {
  ChatRoom chatRoom;
  List<ChatMessage> unsendedMessages;

  ChatScreenViewModel({this.chatRoom, this.unsendedMessages = const []});
}
