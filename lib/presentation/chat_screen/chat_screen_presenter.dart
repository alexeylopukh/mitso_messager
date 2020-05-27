import 'package:flutter/cupertino.dart';
import 'package:messager/interactor/socket_interactor.dart';
import 'package:messager/interactor/typing_detector.dart';
import 'package:messager/objects/chat_message.dart';
import 'package:messager/objects/chat_room.dart';
import 'package:messager/presentation/chat_screen/chat_screen_view_model.dart';
import 'package:messager/presentation/di/user_scope_data.dart';
import 'package:messager/presentation/helper/socket_helper.dart';
import 'package:rxdart/rxdart.dart';

class ChatScreenPresenter {
  final UserScopeData userScope;
  final int roomId;
  BehaviorSubject<ChatScreenViewModel> _viewModelStream;

  ChatScreenPresenter({@required this.userScope, @required this.roomId}) {
    socketInteractor.chatRoomStream.listen((_) {
      var vm = _viewModelStream.value;
      vm.chatRoom = _getCurrentRoom();
      _viewModelStream.add(vm);
    });
    socketInteractor.unsendedMessages.listen((List<ChatMessage> messages) {
      var vm = _viewModelStream.value;
      List<ChatMessage> unsendedMessages = [];
      if (messages.isNotEmpty)
        messages.forEach((ChatMessage message) {
          if (message.roomId == roomId) unsendedMessages.add(message);
        });
      vm.unsendedMessages =
          unsendedMessages.isNotEmpty ? unsendedMessages.reversed.toList() : [];
      _viewModelStream.add(vm);
    });
    _viewModelStream = BehaviorSubject.seeded(
        ChatScreenViewModel(chatRoom: _getCurrentRoom()));
    TypingDetector(
        textEditingController: messageController,
        onStopTyping: () => sendTypingStatus(false),
        onStartTyping: () => sendTypingStatus(true));
  }

  TextEditingController messageController = TextEditingController();
  SocketHelper get _socket => userScope.socketHelper;
  SocketInteractor get socketInteractor => _socket.socketInteractor;
  ValueStream<ChatScreenViewModel> get viewModelSteam =>
      _viewModelStream.stream;

  ChatRoom _getCurrentRoom() {
    List<ChatRoom> chatRooms = socketInteractor.chatRoomStream.value;
    var roomsIterator = chatRooms.iterator;
    ChatRoom foundedRoom;
    while (roomsIterator.moveNext()) {
      ChatRoom currentRoom = roomsIterator.current;
      if (currentRoom.id == roomId) {
        foundedRoom = currentRoom;
        break;
      }
    }
    return foundedRoom;
  }

  sendTypingStatus(bool isTyping) {
    socketInteractor.sendTypingStatus(isTyping, roomId);
  }

  onSendButtonClick() {
    String message = messageController.text.trim();
    if (message.isEmpty) return;
    messageController.clear();
    socketInteractor.sendMessage(roomId, message);
  }

  dispose() {
    _viewModelStream.close();
  }
}
