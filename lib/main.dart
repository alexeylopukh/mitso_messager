import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:messager/presentation/components/keyboard_size.dart';
import 'package:messager/presentation/di/custom_theme.dart';
import 'package:messager/presentation/di/user_scope_data.dart';
import 'package:messager/presentation/main_screen/main_screen.dart';

import 'presentation/auth_screen/auth_screen.dart';

void main() {
  return runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> with WidgetsBindingObserver {
  static const String _title = 'MiMessenger';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    return UserScopeWidget(
      child: CustomTheme(
        child: Builder(
          builder: (context) {
            return StreamBuilder(
                stream: UserScopeWidget.of(context).init(),
                builder: (context, snapshot) {
                  return MaterialApp(
                    title: _title,
                    color: Colors.white,
                    home: KeyboardSize(
                      child: snapshot.data == null
                          ? Container(
                              width: double.infinity,
                              height: double.infinity,
                              color: Color(0xffF3F3F3),
                            )
                          : UserScopeWidget.of(context).token == null
                              ? AuthScreen()
                              : MainScreen(),
                      userScope: UserScopeWidget.of(context),
                    ),
                    theme: ThemeData(
                        appBarTheme: AppBarTheme(color: Colors.transparent),
                        fontFamily: 'SFProDisplay',
                        backgroundColor: Color(0xffF3F3F3),
                        primaryColor: Color(0xff34ABEB)),
                  );
                });
          },
        ),
      ),
    );
  }
}
