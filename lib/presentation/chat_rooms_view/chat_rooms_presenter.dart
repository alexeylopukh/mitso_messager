import 'package:messager/interactor/socket_interactor.dart';
import 'package:messager/objects/chat_room.dart';
import 'package:messager/presentation/chat_rooms_view/chat_rooms_view_model.dart';
import 'package:messager/presentation/di/user_scope_data.dart';
import 'package:rxdart/rxdart.dart';

class ChatRoomsPresenter {
  final UserScopeData userScope;
  SocketInteractor get socketInteractor => userScope.socketInteractor;

  ChatRoomsPresenter(this.userScope) {
    _viewModelStream =
        BehaviorSubject.seeded(ChatRoomsViewModel(rooms: socketInteractor.chatRoomStream.value));
    socketInteractor.chatRoomStream.listen((List<ChatRoom> rooms) {
      _viewModelStream.add(ChatRoomsViewModel(rooms: rooms));
    });
    userScope.deleteChatStream.stream.listen((int messageId) {
      _viewModelStream.stream.value.rooms.forEach((room) {
        try {
          room.messages.removeWhere((message) {
            return message.id == messageId;
          });
        } catch (e) {}
      });
      socketInteractor.chatRoomStream.add(_viewModelStream.stream.value.rooms);
    });
  }
  BehaviorSubject<ChatRoomsViewModel> _viewModelStream;

  ValueStream<ChatRoomsViewModel> get viewModelStream => _viewModelStream;
  dispose() {
    _viewModelStream.close();
  }
}
