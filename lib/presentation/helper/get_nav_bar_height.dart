import 'package:flutter/services.dart';

class GetNavBarHeight {
  static const platform = const MethodChannel('Channel.GetNavBatHeight');

  static Future<int> getNavBarHeight() async {
    int response = 0;
    try {
      final int result = await platform.invokeMethod('GetNavBatHeight');
      response = result;
    } on PlatformException catch (_) {
      return -1;
    }
    print(response);
    return response;
  }
}
