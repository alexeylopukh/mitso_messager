import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:messager/constants.dart';
import 'package:messager/interactor/socket_interactor.dart';
import 'package:messager/objects/chat_message.dart';
import 'package:messager/objects/chat_room.dart';
import 'package:messager/objects/profile.dart';
import 'package:messager/objects/typing_user.dart';
import 'package:messager/presentation/di/user_scope_data.dart';
import 'package:rxdart/rxdart.dart';
import 'package:socket_io_client/socket_io_client.dart';

class SocketHelper {
  Socket _socket;
  Completer _pingCompleter;
  bool _authIsSended = false;
  final UserScopeData userScope;
  SocketInteractor socketInteractor;

  Completer<bool> joinChatCompleter;
  Completer<bool> createRoomCompleter;
  Completer<bool> chatHistoryCompleter;

  SocketHelper({@required this.userScope}) {
    _socket = io(WEB_SOCKET_URL, <String, dynamic>{
      'path': '/srv/',
      'transports': ['websocket'],
    });
    socketInteractor = SocketInteractor(this, this.userScope);
    _initListeners();
  }

  BehaviorSubject<bool> _isSocketConnected = BehaviorSubject.seeded(false);
  ValueStream<bool> get isSocketConnectionStream => _isSocketConnected.stream;

  BehaviorSubject<bool> _isSocketAuth = BehaviorSubject.seeded(false);
  ValueStream<bool> get isSocketAuthStream => _isSocketAuth.stream;

  sendData(String event, Map<String, dynamic> data) {
    _socket.emit(event, jsonEncode(data));
  }

  Future<bool> auth(String authToken) async {
    String pushToken = await userScope.fcmToken();
    chatHistoryCompleter = Completer();
    if (!_authIsSended) {
      _authIsSended = true;
      print('send auth');
      _socket.emit('auth', jsonEncode({'token': authToken, 'push_token': pushToken ?? ""}));
    }
    var result = await chatHistoryCompleter.future.timeout(Duration(seconds: 2)).catchError((e) {});
    print(result);
    if (result == true) _isSocketAuth.add(true);
    return result == true;
  }

  disconnect() {
    _socket.disconnect();
  }

  _setStatusConnection(bool isConnected) {
    if (isConnected) {
      _isSocketConnected.add(true);
    } else {
      _isSocketAuth.add(false);
      _authIsSended = false;
      _isSocketConnected.add(false);
    }
  }

  sendTypingStatus(bool isTyping, int roomId) {
    sendData('on_typing', {'typing': isTyping, 'room_id': roomId});
  }

  _initListeners() {
    _socket.on('connect', (value) {
      _setStatusConnection(true);
      print("CONNECT");
    });
    _socket.on('ping', (value) async {
      _pingCompleter = Completer();
      _pingCompleter.future.timeout(Duration(seconds: 3), onTimeout: () {
        _socket.disconnect();
      });
    });
    _socket.on('pong', (value) {
      _pingCompleter.complete();
    });
    _socket.on('onRooms', (value) {
      print(value);
    });
    _socket.on('disconnect', (value) {
      _setStatusConnection(false);
      print("DISCONNECT");
    });
    _socket.on('on_chat_message', (value) {
      var message = ChatMessage.fromJson(value);
      socketInteractor.handleNewMessage(message);
      print(value);
    });
    _socket.on('on_rooms', (value) {
      List<ChatRoom> rooms = List<ChatRoom>.from(value.map((x) => ChatRoom.fromJson(x)));
      socketInteractor.appendChatRooms(rooms);
      if (chatHistoryCompleter != null) {
        chatHistoryCompleter.complete(true);
      }
    });
    _socket.on('on_create_room', (value) {
      if (createRoomCompleter != null) {
        createRoomCompleter.complete(value != null);
      }
    });
    _socket.on('on_join_chat', (value) {
      if (joinChatCompleter != null) {
        joinChatCompleter.complete(value != null);
      }
    });
    _socket.on('on_typing', (value) {
      if (value['profile'] == null || value['typing'] == null || value['room_id'] == null) return;
      Profile profile = Profile.fromJson(value['profile']);
      bool isTyping = value['typing'];
      int roomId = value['room_id'];
      if (profile != null && isTyping != null && roomId != null)
        userScope.socketInteractor.typingUsersStream.add(TypingUser(profile, isTyping, roomId));
    });
    _socket.on(
        'on_news',
        (data) => {
              //test
              print(data)
            });
    _socket.on(
        'on_create_news',
        (data) => {
              //test
              print(data)
            });
  }

  connect() {
    _socket.connect();
  }

  dispose() {
    _isSocketAuth.close();
    disconnect();
  }
}
