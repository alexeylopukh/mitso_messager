import 'package:messager/objects/chat_message.dart';
import 'package:messager/objects/chat_room.dart';

class ChatScreenViewModel {
  ChatRoom chatRoom;
  List<ChatMessage> messages;

  ChatScreenViewModel({this.chatRoom, this.messages});
}
