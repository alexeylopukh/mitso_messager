import 'dart:async';

import 'package:flutter/material.dart';
import 'package:messager/presentation/di/user_scope_data.dart';

class SocketConnectorInteractor {
  final UserScopeData userScope;

  SocketConnectorInteractor(this.userScope) {
    userScope.socketHelper.isSocketConnectionStream.listen((isConnect) {
      if (!isConnect && !_needToCloseConnection) {
        _webSocketAuth();
      }
    });
  }

  bool _needToCloseConnection = false;

  Completer<bool> disconnectBackgroundCompleter;

  _webSocketAuth() async {
    String token = userScope.authToken();
    await _waitingConnection();
    if (userScope.socketHelper.isSocketAuthStream.valueWrapper.value == true) return;
    bool isAuth = await userScope.socketHelper.auth(token);
    if (isAuth != true) _webSocketAuth();
  }

  Future _waitingConnection() async {
    Completer connectionCompleter = Completer();
    userScope.socketHelper.isSocketConnectionStream.listen((bool isConnected) {
      if (isConnected == true && !connectionCompleter.isCompleted) connectionCompleter.complete();
    });
    await connectionCompleter.future.catchError((e) {});
    return;
  }

  _resumeConnection() {
    userScope.socketHelper.connect();
    _webSocketAuth();
  }

  onChangeAppLifeCircle(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        _needToCloseConnection = false;
        if (disconnectBackgroundCompleter != null) disconnectBackgroundCompleter.complete(true);
        if (!userScope.socketHelper.isSocketConnectionStream.valueWrapper.value)
          _resumeConnection();
        break;
      case AppLifecycleState.paused:
        disconnectBackgroundCompleter = Completer();
        var needDisconnect = !await disconnectBackgroundCompleter.future
            .timeout(Duration(seconds: 60), onTimeout: () {
          return false;
        });
        disconnectBackgroundCompleter = null;
        if (needDisconnect == true) {
          _needToCloseConnection = true;
          userScope.socketHelper.disconnect();
        }
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
        break;
    }
  }
}
