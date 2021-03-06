import 'dart:async';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:messager/data/store/local/rooms_local_store.dart';
import 'package:messager/interactor/socket_interactor.dart';
import 'package:messager/objects/profile.dart';
import 'package:messager/presentation/components/keyboard_size.dart';
import 'package:messager/presentation/helper/fcm_helper.dart';
import 'package:messager/presentation/helper/socket_helper.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserScopeData {
  UserScopeWidgetState state;
  bool isColdStart;
  FcmHelper fcmHelper;
  SocketHelper socketHelper;
  SocketInteractor get socketInteractor => socketHelper.socketInteractor;
  RoomsLocalStore roomsLocalStore;

  UserScopeData({@required this.state, @required this.isColdStart}) {
    roomsLocalStore = RoomsLocalStore(this);
  }

  BehaviorSubject<KeyboardOpenedData> keyboardStream =
      BehaviorSubject.seeded(KeyboardOpenedData(0, false));

  BehaviorSubject<String> messagesStream = BehaviorSubject();

  BehaviorSubject<int> goToChatRoomStream = BehaviorSubject();

  String token;
  Profile myProfile;

  Stream<bool> init() async* {
    await Firebase.initializeApp();
    await initializeDateFormatting('ru', null);
    token = await authToken();
    myProfile = await getMyProfile();
    fcmHelper = FcmHelper();
    yield true;
  }

  void deauth() {
    setMyProfile(null);
    setAuthToken(null);
  }

  Future<String> fcmToken() async {
    return fcmHelper.getFcmToken();
  }

  Future<String> authToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('authToken');
    return token;
  }

  Future setAuthToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (token != null)
      await prefs.setString('authToken', token);
    else
      await prefs.remove('authToken');
    state.rebuild();
  }

  Future<Profile> getMyProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String json = prefs.getString('profile');
    if (json != null) {
      return Profile.fromJson(jsonDecode(json));
    }
    return null;
  }

  Future setMyProfile(Profile profile) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (profile != null)
      await prefs.setString('profile', jsonEncode(profile.toJson()));
    else
      await prefs.remove('profile');
  }

  Future addKeys(Map<int, String> input) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, String> dataForSave = {};
    Map<int, String> keys = await getKeys();
    keys.addAll(input);
    keys.forEach((key, value) {
      dataForSave[key.toString()] = value;
    });
    prefs.setString('keys', jsonEncode(dataForSave));
  }

  Future<Map<int, String>> getKeys() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var json = prefs.getString('keys');
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

  dispose() {
    messagesStream.close();
    socketInteractor.dispose();
    keyboardStream.close();
    goToChatRoomStream.close();
  }
}

class _UserScopeWidget extends InheritedWidget {
  final UserScopeWidgetState state;
  final UserScopeData data;

  _UserScopeWidget._(Key key, Widget child, this.state, this.data) : super(key: key, child: child) {
    state.isColdStart = false;
  }

  factory _UserScopeWidget(
      {Key key, @required Widget child, @required UserScopeWidgetState state}) {
    return _UserScopeWidget._(
        key, child, state, UserScopeData(state: state, isColdStart: state.isColdStart));
  }

  @override
  bool updateShouldNotify(InheritedWidget old) => true;
}

class UserScopeWidget extends StatefulWidget {
  final Widget child;

  UserScopeWidget({Key key, @required this.child}) : super(key: key);

  static UserScopeData of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<_UserScopeWidget>()).data;
  }

  @override
  State<StatefulWidget> createState() {
    return UserScopeWidgetState(key: key, child: child);
  }
}

class UserScopeWidgetState extends State<UserScopeWidget> {
  Key key;
  Widget child;
  bool isColdStart = true;

  UserScopeWidgetState({this.key, this.child});

  @override
  Widget build(BuildContext context) {
    return _UserScopeWidget(
      key: key,
      child: child,
      state: this,
    );
  }

  rebuild() {
    setState(() {});
  }
}
