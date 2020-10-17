import 'dart:async';

import 'package:messager/data/store/local/unsent_messages_store.dart';
import 'package:messager/objects/chat_message.dart';
import 'package:messager/objects/chat_room.dart';
import 'package:messager/objects/news_model.dart';
import 'package:messager/objects/typing_user.dart';
import 'package:messager/presentation/di/user_scope_data.dart';
import 'package:messager/presentation/helper/socket_helper.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

class SocketInteractor {
  final SocketHelper socket;
  final UserScopeData userScope;

  SocketInteractor(this.socket, this.userScope) {
    userScope.roomsLocalStore.get().then((rooms) {
      chatRoomStream.add(rooms);
    });
    _unsentMessagesStore.get().then((List<ChatMessage> value) {
      unsendedMessages.add(value);
    });
    socket.isSocketAuthStream.listen((isAuth) {
      if (isAuth) _sendFirstUnsendedMessage();
    });
  }

  UnsentMessagesStore _unsentMessagesStore = UnsentMessagesStore();
  BehaviorSubject<List<ChatRoom>> chatRoomStream = BehaviorSubject.seeded([]);
  BehaviorSubject<TypingUser> typingUsersStream = BehaviorSubject();
  BehaviorSubject<List<ChatMessage>> unsendedMessages = BehaviorSubject.seeded([]);
  BehaviorSubject<List<NewsModel>> newsModels = BehaviorSubject.seeded([]);

  DateTime lastSendedMessage;

  handleNewMessage(ChatMessage message) {
    _tryDeleteUnsentMessage(message);
    _appendNewMessage(message);
    _sendFirstUnsendedMessage();
  }

  appendChatRooms(List<ChatRoom> rooms) {
    chatRoomStream.add(rooms);
    userScope.roomsLocalStore.addRooms(rooms);
  }

  sendTypingStatus(bool isTyping, int roomId) {
    socket.sendTypingStatus(isTyping, roomId);
  }

  sendNews(String title, String text) {
    socket.sendData('on_create_news', {"title": title, "text": text, "uuid": Uuid().v4()});
  }

  sendMessage(int roomId, String message, List<String> photos) {
    var chatMessage = ChatMessage(
        roomId: roomId,
        text: message,
        uuid: Uuid().v4(),
        sender: userScope.myProfile,
        date: DateTime.now(),
        photos: photos ?? [],
        isSended: false);
    if (unsendedMessages.value.isNotEmpty) {
      _addNewUnsendedMessage(chatMessage);
    } else {
      _addNewUnsendedMessage(chatMessage);
      _sendMessageWithSocket(chatMessage);
    }
  }

  Future<List<ChatMessage>> getChatHistory(int roomId, int messageId) async {
    print('get');
    socket.getChatMessagesCompleter = Completer();
    socket.sendData('get_chat_message', {"room_id": roomId, "limit": 50, "last_message_id": null});
    List<ChatMessage> messages =
        await socket.getChatMessagesCompleter.future.timeout(Duration(seconds: 3));
    socket.chatHistoryCompleter = null;
    return messages;
  }

  _sendMessageWithSocket(ChatMessage chatMessage) {
    socket.sendData('on_chat_message', {
      "room_id": chatMessage.roomId,
      "uuid": chatMessage.uuid,
      "text": chatMessage.text,
      "photos": chatMessage.photos
    });
  }

  _appendNewMessage(ChatMessage message) async {
    if (chatRoomStream.value == null) return;
    int index = chatRoomStream.value.indexWhere((ChatRoom ch) {
      return ch.id == message.roomId;
    });
    if (index == -1) return;
    chatRoomStream.value[index].messages.insert(0, message);
    chatRoomStream.add(chatRoomStream.value);
    userScope.roomsLocalStore.addRooms(chatRoomStream.value);
  }

  _addNewUnsendedMessage(ChatMessage message) {
    _unsentMessagesStore.addMessage(message);
    unsendedMessages.add(unsendedMessages.value..add(message));
  }

  _tryDeleteUnsentMessage(ChatMessage message) {
    if (unsendedMessages.value.isEmpty) return;
    var messages = unsendedMessages.value;
    var iterator = messages.iterator;
    bool founded = false;
    while (iterator.moveNext()) {
      ChatMessage currentMessage = iterator.current;
      if (currentMessage.uuid == message.uuid) {
        founded = true;
        messages.remove(currentMessage);
        break;
      }
    }
    if (!founded) return;
    _unsentMessagesStore.removeMessage(message);
    unsendedMessages.add(messages);
  }

  _sendFirstUnsendedMessage() async {
    if (lastSendedMessage == null ||
        DateTime.now().difference(lastSendedMessage).inMilliseconds > 900) {
      lastSendedMessage = DateTime.now();
      if (unsendedMessages.value.isEmpty) return;
      _sendMessageWithSocket(unsendedMessages.value.first);
    } else {
      await Future.delayed(Duration(milliseconds: 900));
      _sendFirstUnsendedMessage();
    }
  }

  dispose() {
    socket.dispose();
    chatRoomStream.close();
    typingUsersStream.close();
    unsendedMessages.close();
    newsModels.close();
  }
}
