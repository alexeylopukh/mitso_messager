import 'package:messager/data/store/cloud/chat_key_cloud_store.dart';
import 'package:messager/data/store/local/chat_key_local_store.dart';

class ChatKeysRepository {
  final ChatKeyLocalStore chatKeyLocalStore = ChatKeyLocalStore();
  final ChatKeysCloudStore chatKeysCloudStore;

  Map<int, String> keys;

  ChatKeysRepository(this.chatKeysCloudStore);

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
    try {
      return await chatKeysCloudStore.getKeys();
    } catch (e) {
      await Future.delayed(Duration(seconds: 1));
      return _loadKeys();
    }
  }
}
