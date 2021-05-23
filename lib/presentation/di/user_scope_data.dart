import 'dart:async';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:messager/data/repository/chat_keys_repository.dart';
import 'package:messager/data/repository/documents_repository.dart';
import 'package:messager/data/store/cloud/chat_key_cloud_store.dart';
import 'package:messager/data/store/local/rooms_local_store.dart';
import 'package:messager/interactor/socket_interactor.dart';
import 'package:messager/objects/call_request.dart';
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
  SharedPreferences _prefs;
  ChatKeysRepository chatKeysRepository;
  DocumentsRepository documentsRepository = DocumentsRepository();
  StreamController<CallRequest> incomingCallListener = StreamController.broadcast();

  UserScopeData({@required this.state, @required this.isColdStart}) {
    roomsLocalStore = RoomsLocalStore(this);
    chatKeysRepository = ChatKeysRepository(ChatKeysCloudStore(this));
  }

  BehaviorSubject<KeyboardOpenedData> keyboardStream =
      BehaviorSubject.seeded(KeyboardOpenedData(0, false));

  BehaviorSubject<String> messagesStream = BehaviorSubject();
  StreamController<int> deleteChatStream = StreamController.broadcast();

  BehaviorSubject<int> goToChatRoomStream = BehaviorSubject();

  String token;
  Profile myProfile;

  Stream<bool> init() async* {
    await Firebase.initializeApp();
    await initializeDateFormatting('ru', null);
    _prefs = await SharedPreferences.getInstance();
    token = authToken();
    myProfile = getMyProfile();
    fcmHelper = FcmHelper();
    yield true;
  }

  void deauth() {
    setMyProfile(null);
    setAuthToken(null);
  }

  Future<String> fcmToken() {
    return fcmHelper.getFcmToken();
  }

  String authToken() {
    String token = _prefs.getString('authToken');
    return token;
  }

  Future setAuthToken(String token) async {
    if (token != null)
      await _prefs.setString('authToken', token);
    else
      await _prefs.remove('authToken');
    state.rebuild();
  }

  Profile getMyProfile() {
    String json = _prefs.getString('profile');
    if (json != null) {
      return Profile.fromJson(jsonDecode(json));
    }
    return null;
  }

  Future setMyProfile(Profile profile) async {
    if (profile != null)
      await _prefs.setString('profile', jsonEncode(profile.toJson()));
    else
      await _prefs.remove('profile');
  }

  dispose() {
    messagesStream.close();
    socketInteractor.dispose();
    keyboardStream.close();
    goToChatRoomStream.close();
    incomingCallListener.close();
    deleteChatStream.close();
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
