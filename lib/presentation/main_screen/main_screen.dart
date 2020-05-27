import 'package:flutter/material.dart';
import 'package:messager/presentation/chat_rooms_view/chat_rooms_view.dart';
import 'package:messager/presentation/components/animated_index_stack.dart';
import 'package:messager/presentation/components/general_scaffold.dart';
import 'package:messager/presentation/components/popups.dart';
import 'package:messager/presentation/di/user_scope_data.dart';
import 'package:messager/presentation/main_screen/main_screen_presenter.dart';
import 'package:messager/presentation/more_screen/more_screen.dart';
import 'package:messager/presentation/more_screen/more_screen_tab_bar.dart';

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
      _presenter = MainScreenPresenter(UserScopeWidget.of(context));
      UserScopeWidget.of(context).messagesStream.listen((String message) {
        Popups.showModalDialog(context, PopupState.OK, description: message);
      });
    }
    return GeneralScaffold(
      child: Container(
          child: Stack(
        children: <Widget>[
          AnimatedIndexedStack(
            index: currentTabIndex,
            children: <Widget>[ChatRoomsView(), MoreScreen()],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: MoreScreenTabBar(
              currentTabIndex: currentTabIndex,
              onTabClick: onTabClick,
              items: [
                MoreScreenTab(icon: Icons.message, text: 'Чаты'),
                MoreScreenTab(icon: Icons.menu, text: 'Еще'),
              ],
            ),
          )
        ],
      )),
    );
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
