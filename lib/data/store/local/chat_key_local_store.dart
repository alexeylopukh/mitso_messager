import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class ChatKeyLocalStore {
  SharedPreferences _prefs;

  Future addChatKeys(Map<int, String> input) async {
    await getSp();
    Map<String, String> dataForSave = {};
    Map<int, String> keys = await getChatKeys();
    keys.addAll(input);
    keys.forEach((key, value) {
      dataForSave[key.toString()] = value;
    });
    _prefs.setString('chat_keys', jsonEncode(dataForSave));
    return dataForSave;
  }

  Future<Map<int, String>> getChatKeys() async {
    await getSp();
    var json = _prefs.getString('chat_keys');
    if (json == null || json.isEmpty) {
      return Map<int, String>.of({});
    }
    Map<String, dynamic> enicoded = jsonDecode(json);
    Map<int, String> result = {};
    enicoded.forEach((key, value) {
      result[int.parse(key)] = value;
    });
    return result;
  }

  Future<SharedPreferences> getSp() async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }
    return _prefs;
  }
}
