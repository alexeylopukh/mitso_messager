import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/material.dart';
import 'package:messager/objects/chat_message.dart';
import 'package:messager/objects/chat_room.dart';
import 'package:messager/presentation/di/user_scope_data.dart';

class EncryptInteractor {
  final encrypt.IV iv = encrypt.IV.fromLength(15);
  final UserScopeData userScope;

  EncryptInteractor(this.userScope);

  Future<String> cryptMessage(int roomId, String message) async {
    final roomKey = await userScope.chatKeysRepository.getRoomKey(roomId);
    final encrypter = _createEncrypter(roomKey);
    return _encryptMessage(message: message, encrypter: encrypter);
  }

  Future decryptMessage(ChatMessage message) async {
    final roomKey = await userScope.chatKeysRepository.getRoomKey(message.roomId);
    final encrypter = _createEncrypter(roomKey);
    message.encryptedMessage =
        _decryptMessage(message: message.cryptedMessage, encrypter: encrypter);
  }

  Future decryptRooms(List<ChatRoom> rooms) async {
    var roomsInteractor = rooms.iterator;
    while (roomsInteractor.moveNext()) {
      ChatRoom chatRoom = roomsInteractor.current;
      if (chatRoom.messages != null && chatRoom.messages.isNotEmpty) {
        await decryptMessagesFromRoom(chatRoom.messages, chatRoom.id);
      }
    }
  }

  Future decryptMessagesFromRoom(List<ChatMessage> messages, int roomId) async {
    final roomKey = await userScope.chatKeysRepository.getRoomKey(roomId);
    final encrypter = _createEncrypter(roomKey);
    messages.forEach((element) {
      try {
        element.encryptedMessage =
            _decryptMessage(message: element.cryptedMessage, encrypter: encrypter);
      } catch (e) {}
    });
  }

  encrypt.Encrypter _createEncrypter(String keyString) {
    final encrypt.Key key = encrypt.Key.fromBase64(keyString);
    return encrypt.Encrypter(encrypt.AES(key));
  }

  String _encryptMessage({@required message, @required encrypt.Encrypter encrypter}) {
    return encrypter.encrypt(message, iv: iv).base64;
  }

  String _decryptMessage({@required message, @required encrypt.Encrypter encrypter}) {
    return encrypter.decrypt(encrypt.Encrypted.from64(message), iv: iv);
  }
}
