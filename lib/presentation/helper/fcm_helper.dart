import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';

class FcmHelper {
  FcmHelper() {
    init();
  }

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  init() async {
    if (Platform.isIOS) await _iosPermission();

    _firebaseMessaging.getToken().then((token) {
      print('push token:');
      print(token);
    });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
      },
    );
  }

  Future<String> getFcmToken() async {
    String token = await _firebaseMessaging.getToken();
    return token;
  }

  Future _iosPermission() async {
    Completer completer = Completer();
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      completer.complete();
      print("Settings registered: $settings");
    });
    await completer.future;
    return;
  }
}
