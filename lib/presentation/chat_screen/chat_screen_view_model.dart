import 'package:messager/objects/chat_message.dart';
import 'package:messager/objects/chat_room.dart';
import 'package:messager/objects/profile.dart';

class ChatScreenViewModel {
  ChatRoom chatRoom;
  List<ChatMessage> messages;
  List<Profile> users;

  ChatScreenViewModel({this.chatRoom, this.messages, this.users});
}
