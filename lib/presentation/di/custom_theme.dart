import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTheme extends InheritedWidget {
  final defaultFontFamily = 'SFProDisplay';
  final boldFontFamily = 'SFProDisplay-Bold';

  final primaryColor = Color(0xff34ABEB);
  final secondColor = Color(0xff29E6A6);
  final backgroundColor = Color(0xffF3F3F3);
  final grayColor = Color(0xff595959);
  final textBlackColor = Color(0xff333333);
  final textBlackGrayColor = Color(0xff505050);

  CustomTheme({Key key, @required Widget child})
      : super(key: key, child: child);

  static CustomTheme of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<CustomTheme>());
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }

  void setBrightStatusBarIcons() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }

  void setDarkStatusBarIcons() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(
        statusBarBrightness: Brightness.dark,
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }
}
