import 'package:flutter/cupertino.dart';
import 'package:messager/interactor/join_room_interactor.dart';
import 'package:messager/presentation/di/user_scope_data.dart';
import 'package:url_launcher/url_launcher.dart';

import 'incoming_uri_helper.dart';

class OpenUrlHelper {
  openUrl(String url, BuildContext context) async {
    IncomingUriHelperData data = IncomingUriHelper().incomingUriHandler(Uri.parse(url));
    if (data != null)
      _handleUrl(data, context);
    else if (await canLaunch(url)) {
      await launch(url);
    }
  }

  _handleUrl(IncomingUriHelperData data, BuildContext context) {
    switch (data.type) {
      case IncomingUriType.JoinRoom:
        IncomingUriJoinRoomData uriJoinRoomData = data;
        if (uriJoinRoomData.uuid != null && uriJoinRoomData.roomId != null) {
          JoinRoomInteractor(UserScopeWidget.of(context)).join(uriJoinRoomData.roomId);
        }
        break;
    }
  }
}
