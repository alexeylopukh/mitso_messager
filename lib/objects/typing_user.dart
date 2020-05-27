import 'package:messager/objects/profile.dart';

class TypingUser {
  Profile profile;
  bool isTyping;
  int roomId;

  TypingUser(this.profile, this.isTyping, this.roomId);
}
