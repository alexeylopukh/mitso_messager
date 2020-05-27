import 'package:flutter/cupertino.dart';
import 'package:messager/constants.dart';

const List<String> domains = [UNI_LINKS_DOMAIN];
// ignore: slash_for_doc_comments
/**
 join to room
https://mitsomessanger.org/join_room?room_id=3&token=7e62543e-83bf-45af-8b10-5efef2a26242
 **/

class IncomingUriHelper {
  IncomingUriHelperData incomingUriHandler(Uri uri) {
    if (uri == null) return null;
    List<String> splitUri = uri.host.split('.');
    if (splitUri.length < 2) return null;
    String currentDomain =
        splitUri[splitUri.length - 2] + '.' + splitUri[splitUri.length - 1];
    if (!domains.contains(currentDomain)) return null;

    List<String> segments = uri.pathSegments;
    if (segments.isEmpty) return null;

    /// Check for post url
    if (segments.first.toLowerCase() == 'join_room') {
      IncomingUriJoinRoomData postData = _extractJoinRoomData(uri);
      if (postData != null) return postData;
    }
    return null;
  }

  IncomingUriJoinRoomData _extractJoinRoomData(Uri uri) {
    List<String> segments = uri.pathSegments;
    int roomId;
    if (segments.length >= 1 && (segments[0].toLowerCase() == 'join_room')) {
      if (uri.queryParameters['room_id'] != null) {
        roomId = int.parse(uri.queryParameters['room_id']);
      }
      String uuid;
      if (uri.queryParameters['token'] != null) {
        uuid = uri.queryParameters['token'];
      }

      return IncomingUriJoinRoomData(
          type: IncomingUriType.JoinRoom, uuid: uuid, roomId: roomId);
    } else
      return null;
  }
}

enum IncomingUriType { JoinRoom }

abstract class IncomingUriHelperData {
  final IncomingUriType type;

  IncomingUriHelperData(this.type);
}

class IncomingUriJoinRoomData implements IncomingUriHelperData {
  final IncomingUriType type;
  final int roomId;
  final String uuid;

  IncomingUriJoinRoomData(
      {@required this.type, @required this.roomId, @required this.uuid});
}
