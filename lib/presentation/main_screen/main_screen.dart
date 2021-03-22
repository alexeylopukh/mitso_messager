import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:messager/presentation/chat_rooms_view/chat_rooms_view.dart';
import 'package:messager/presentation/components/animated_index_stack.dart';
import 'package:messager/presentation/components/general_scaffold.dart';
import 'package:messager/presentation/components/popups.dart';
import 'package:messager/presentation/di/user_scope_data.dart';
import 'package:messager/presentation/helper/incoming_push_token.dart';
import 'package:messager/presentation/live_video_chat_screen/live_chat_call_screen.dart';
import 'package:messager/presentation/main_screen/main_screen_presenter.dart';
import 'package:messager/presentation/more_screen/more_screen.dart';
import 'package:messager/presentation/more_screen/more_screen_tab_bar.dart';
import 'package:messager/presentation/news_screen/news_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with WidgetsBindingObserver {
  MainScreenPresenter _presenter;

  int currentTabIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    if (_presenter == null) {
      init();
      UserScopeWidget.of(context).incomingCallListener.stream.listen((event) {
        Navigator.of(context).push(MaterialPageRoute(builder: (c) {
          return CallPage(
            role: ClientRole.Broadcaster,
            channelName: 'test',
          );
        }));
      });
    }
    return GeneralScaffold(
      child: Container(
          child: Stack(
        children: <Widget>[
          AnimatedIndexedStack(
            index: currentTabIndex,
            children: <Widget>[ChatRoomsView(), NewsScreen(), MoreScreen()],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: MoreScreenTabBar(
              currentTabIndex: currentTabIndex,
              onTabClick: onTabClick,
              items: [
                MoreScreenTab(icon: Icons.message, text: 'Чаты'),
                MoreScreenTab(icon: Icons.assignment, text: 'Новости'),
                MoreScreenTab(icon: Icons.menu, text: 'Еще'),
              ],
            ),
          )
        ],
      )),
    );
  }

  init() {
    _presenter = MainScreenPresenter(UserScopeWidget.of(context));
    UserScopeWidget.of(context).messagesStream.listen((String message) {
      Popups.showModalDialog(context, PopupState.OK, description: message);
    });
    // FirebaseMessaging.onMessage.listen((event) {
    //   // print('onMessage');
    //   // return IncomingPushHelper().handlePush(event.data, _presenter.userScope);
    // });
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      print('onMessageOpenedApp');
      return IncomingPushHelper().handlePush(event.data, _presenter.userScope);
    });
  }

  onTabClick(int index) {
    currentTabIndex = index;
    setState(() {});
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) =>
      _presenter.onChangeAppLifeCircle(state);

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _presenter.dispose();
    super.dispose();
  }
}
