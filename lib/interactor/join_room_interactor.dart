import 'dart:async';

import 'package:messager/presentation/di/user_scope_data.dart';

class JoinRoomInteractor {
  final UserScopeData userScope;

  JoinRoomInteractor(this.userScope);

  join(int roomId) async {
    userScope.socketHelper.joinChatCompleter = Completer();
    userScope.socketHelper.sendData('on_join_chat', {"room_id": roomId});
    var result = await userScope.socketHelper.joinChatCompleter.future
        .timeout(Duration(seconds: 3))
        .catchError((e) {});
    if (result != null) {
      userScope.socketHelper.chatHistoryCompleter = Completer();
      userScope.socketHelper.sendData('on_rooms', {});
      bool isRoomsUpdated = await userScope
          .socketHelper.chatHistoryCompleter.future
          .timeout(Duration(seconds: 3))
          .catchError((e) {});
      if (isRoomsUpdated) {
        userScope.goToChatRoomStream.add(roomId);
      }
    } else {
      userScope.messagesStream.add('Не удалось присоединиться к комнате');
    }
  }
}
