import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';

class FcmHelper {
  FcmHelper() {
    init();
  }

  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  init() async {
    if (Platform.isIOS) await _iosPermission();
  }

  Future<String> getFcmToken() async {
    String token = await firebaseMessaging.getToken();
    return token;
  }

  Future _iosPermission() async {
    await firebaseMessaging.requestPermission(sound: true, badge: true, alert: true);
    return;
  }
}
