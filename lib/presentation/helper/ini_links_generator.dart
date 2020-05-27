import 'package:messager/constants.dart';
import 'package:uuid/uuid.dart';

class UniLinksGenerator {
  String generateJoinChatLink(int roomId) {
    return 'https://$UNI_LINKS_DOMAIN/join_room?room_id=$roomId&token=${Uuid().v4()}';
  }
}
