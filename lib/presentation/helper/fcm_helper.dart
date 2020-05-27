import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';

class FcmHelper {
  FcmHelper() {
    init();
  }

  FirebaseMessaging firebaseMessaging = FirebaseMessaging();

  init() async {
    if (Platform.isIOS) await _iosPermission();
  }

  Future<String> getFcmToken() async {
    String token = await firebaseMessaging.getToken();
    return token;
  }

  Future _iosPermission() async {
    Completer completer = Completer();
    firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    firebaseMessaging.onIosSettingsRegistered.listen((IosNotificationSettings settings) {
      completer.complete();
      print("Settings registered: $settings");
    });
    await completer.future;
    return;
  }
}
