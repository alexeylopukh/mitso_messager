import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:messager/presentation/di/custom_theme.dart';

const double _TAB_HEIGHT = 55.0;

class MoreScreenTabBar extends StatefulWidget {
  final List<MoreScreenTab> items;
  final int currentTabIndex;
  final Function(int) onTabClick;

  const MoreScreenTabBar(
      {Key key, @required this.items, @required this.currentTabIndex, @required this.onTabClick})
      : super(key: key);

  @override
  _MoreScreenTabBarState createState() => _MoreScreenTabBarState();
}

class _MoreScreenTabBarState extends State<MoreScreenTabBar> {
  @override
  Widget build(BuildContext context) {
    List<Widget> tabs = [];
    for (int i = 0; i < widget.items.length; i++) {
      var item = widget.items[i];
      tabs.add(Expanded(
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              widget.onTabClick(i);
            },
            child: Container(
              height: _TAB_HEIGHT,
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(
                    item.icon,
                    color: i == widget.currentTabIndex
                        ? CustomTheme.of(context).primaryColor
                        : CustomTheme.of(context).grayColor,
                  ),
                  Text(
                    item.text,
                    style: TextStyle(
                        color: i == widget.currentTabIndex
                            ? CustomTheme.of(context).primaryColor
                            : CustomTheme.of(context).grayColor,
                        fontSize: 16),
                  )
                ],
              ),
            ),
          ),
        ),
      ));
    }
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).padding.bottom +
          MediaQuery.of(context).viewInsets.bottom +
          _TAB_HEIGHT,
      decoration: BoxDecoration(
          color: CustomTheme.of(context).backgroundColor.withOpacity(0.9),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 1,
              offset: Offset(0, -1),
            ),
          ]),
      child: Padding(
        padding: EdgeInsets.only(
            bottom:
                MediaQuery.of(context).viewInsets.bottom + MediaQuery.of(context).padding.bottom),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: tabs,
        ),
      ),
    );
  }
}

class MoreScreenTab {
  final IconData icon;
  final String text;

  MoreScreenTab({@required this.icon, @required this.text});
}
