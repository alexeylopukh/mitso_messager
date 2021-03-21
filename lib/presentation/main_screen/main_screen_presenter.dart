import 'dart:async';

import 'package:flutter/material.dart';
import 'package:messager/interactor/join_room_interactor.dart';
import 'package:messager/interactor/socket_connector_interactor.dart';
import 'package:messager/presentation/di/user_scope_data.dart';
import 'package:messager/presentation/helper/incoming_uri_helper.dart';
import 'package:messager/presentation/helper/socket_helper.dart';

class MainScreenPresenter {
  final UserScopeData userScope;

  MainScreenPresenter(this.userScope) {
    userScope.socketHelper = SocketHelper(userScope: userScope);
    _socketConnectorInteractor = SocketConnectorInteractor(userScope);
    if (coldStartUriChecked == false) {
      // checkColdStartUniLinksUri();
      coldStartUriChecked = true;
    }
  }
  IncomingUriHelper _incomingUriHelper = IncomingUriHelper();

  StreamSubscription incomingUriStreamSubscription;
  SocketConnectorInteractor _socketConnectorInteractor;
  bool coldStartUriChecked = false;

  onChangeAppLifeCircle(AppLifecycleState state) {
    _socketConnectorInteractor.onChangeAppLifeCircle(state);
  }

  void processExternalLink(Uri uri) {
    IncomingUriHelperData data = _incomingUriHelper.incomingUriHandler(uri);
    if (data == null) return;
    switch (data.type) {
      case IncomingUriType.JoinRoom:
        IncomingUriJoinRoomData uriJoinRoomData = data;
        if (uriJoinRoomData.uuid != null && uriJoinRoomData.roomId != null) {
          JoinRoomInteractor(userScope).join(uriJoinRoomData.roomId);
        }
        break;
    }
  }

  // checkColdStartUniLinksUri() async {
  //   if (userScope.isColdStart == false) return;
  //
  //   Uri uri = await getInitialUri();
  //   if (uri != null) processExternalLink(uri);
  // }

  dispose() {
    userScope.socketInteractor?.dispose();
    incomingUriStreamSubscription?.cancel();
  }
}
