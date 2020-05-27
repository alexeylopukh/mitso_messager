import 'package:messager/objects/chat_room.dart';
import 'package:messager/presentation/di/user_scope_data.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

const String _DB_NAME = "rooms_store.db";
const String _ROOMS_RECORD = "rooms";

class RoomsLocalStore {
  final UserScopeData userScope;
  final _store = StoreRef<String, List<dynamic>>.main();
  Database _db;

  RoomsLocalStore(this.userScope) {
    _openDatabase();
  }

  Future addRooms(List<ChatRoom> rooms) async {
    await _openDatabase();
    List<ChatRoom> roomsFromDb = await get();

    var json = List<dynamic>.from(rooms.map((x) => x.toJson()));
    if (roomsFromDb.isEmpty)
      await _store.record(_ROOMS_RECORD).add(_db, json);
    else
      await _store.record(_ROOMS_RECORD).update(_db, json);
  }

  Future<List<ChatRoom>> get() async {
    await _openDatabase();
    final List<dynamic> json = await _store.record(_ROOMS_RECORD).get(_db);
    if (json != null) {
      List<ChatRoom> rooms =
          List<ChatRoom>.from(json.map((x) => ChatRoom.fromJson(x)));
      return rooms;
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
