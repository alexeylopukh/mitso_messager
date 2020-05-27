import 'package:messager/objects/chat_message.dart';
import 'package:messager/objects/chat_messages.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

const String _DB_NAME = "unsent_messages.db";
const String _RECORD_KEY = 'room_messages';

class UnsentMessagesStore {
  final _store = StoreRef<String, Map<String, dynamic>>.main();
  Database _db;

  UnsentMessagesStore() {
    _openDatabase();
  }

  Future removeMessage(ChatMessage message) async {
    await _openDatabase();
    List<ChatMessage> messages = await get();
    if (messages.isEmpty) return;
    var iterator = messages.iterator;
    while (iterator.moveNext()) {
      ChatMessage currentMessage = iterator.current;
      if (currentMessage.uuid == message.uuid) {
        messages.remove(currentMessage);
        break;
      }
    }
    await _store
        .record(_RECORD_KEY)
        .update(_db, ChatMessages(messages: messages).toJson());
  }

  Future addMessage(ChatMessage message) async {
    await _openDatabase();
    List<ChatMessage> messages = await get();
    bool messagesIsEmpty = messages.isEmpty;
    messages.add(message);

    var json = ChatMessages(messages: messages).toJson();
    if (messagesIsEmpty)
      await _store.record(_RECORD_KEY).put(_db, json);
    else
      await _store.record(_RECORD_KEY).update(_db, json);
  }

  Future replaceMessages(List<ChatMessage> messages) async {
    await _openDatabase();
    await _store
        .record(_RECORD_KEY)
        .update(_db, ChatMessages(messages: messages).toJson());
  }

  Future<List<ChatMessage>> get() async {
    await _openDatabase();
    final Map<String, dynamic> json = await _store.record(_RECORD_KEY).get(_db);
    if (json != null) {
      ChatMessages messages = ChatMessages.fromJson(json);
      return messages.messages;
    } else
      return [];
  }

  Future _openDatabase() async {
    if (_db != null) return;
    final appDocumentDir = await getApplicationDocumentsDirectory();
    final dpPath = '${appDocumentDir.path}/$_DB_NAME';
    _db = await databaseFactoryIo.openDatabase(dpPath);
  }
}
