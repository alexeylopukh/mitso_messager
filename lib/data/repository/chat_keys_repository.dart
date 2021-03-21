import 'package:messager/data/store/local/chat_key_local_store.dart';

class ChatKeysRepository {
  final ChatKeyLocalStore chatKeyLocalStore = ChatKeyLocalStore();

  Map<int, String> keys;

  Future<String> getRoomKey(int roomId) async {
    if (keys == null || !keys.containsKey(roomId)) {
      await loadChatKeys(roomId);
    }
    return keys[roomId];
  }

  Future loadChatKeys([int roomId]) async {
    keys = await chatKeyLocalStore.getChatKeys();
    if (keys == null || !keys.containsKey(roomId)) keys = await _loadKeys();
  }

  Future _loadKeys() async {
    keys = await chatKeyLocalStore.addChatKeys({1: "k3N92Fu1c19GUSoxXXkUjvcsYTK43dGAyzu7CA6Lkiw="});
    return keys;
  }
}
