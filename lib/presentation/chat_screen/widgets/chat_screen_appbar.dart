import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:messager/objects/chat_room.dart';
import 'package:messager/presentation/components/avatar_view.dart';
import 'package:messager/presentation/di/custom_theme.dart';
import 'package:messager/presentation/helper/ini_links_generator.dart';
import 'package:messager/presentation/qr_code_view/qr_code_view.dart';

class ChatScreenAppBar extends StatefulWidget {
  final ChatRoom chatRoom;

  const ChatScreenAppBar({Key key, @required this.chatRoom}) : super(key: key);

  @override
  _ChatScreenAppBarState createState() => _ChatScreenAppBarState();
}

class _ChatScreenAppBarState extends State<ChatScreenAppBar> {
  bool isMenuOpened = false;

  ChatRoom get chatRoom => widget.chatRoom;

  @override
  Widget build(BuildContext context) {
    double navBarHeight = MediaQuery.of(context).padding.top + 55;
    double navBarWithMenu = navBarHeight + 130;
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.ease,
      height: isMenuOpened ? navBarWithMenu : navBarHeight,
      decoration: BoxDecoration(
          color: CustomTheme.of(context).backgroundColor.withOpacity(0.9),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 1,
              offset: Offset(0, 1),
            ),
          ]),
      child: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              height: 55,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      if (isMenuOpened) {
                        isMenuOpened = false;
                        setState(() {});
                      } else
                        onBackButtonPress();
                    },
                    child: Container(
                      width: 45,
                      height: 55,
                      alignment: Alignment.center,
                      child: SizedBox(
                          height: 24,
                          width: 24,
                          child: SvgPicture.asset('assets/icons/ic_back.svg')),
                    ),
                  ),
                  Hero(
                      tag: chatRoom.id,
                      child: AvatarView(
                        avatarKey: chatRoom.imageKey,
                        name: chatRoom.name,
                        size: 45.0,
                      )),
                  Container(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          chatRoom.name,
                          style: TextStyle(
                              color: CustomTheme.of(context).textBlackGrayColor,
                              fontFamily: CustomTheme.of(context).boldFontFamily,
                              fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      isMenuOpened = !isMenuOpened;
                      setState(() {});
                    },
                    child: Container(
                      width: 45,
                      height: 55,
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.more_vert,
                        size: 24,
                        color: CustomTheme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (isMenuOpened) navBarMenu(),
          ],
        ),
      ),
    );
  }

  Widget navBarMenu() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (chatRoom.id != 1)
          Padding(
            padding: const EdgeInsets.only(left: 50, right: 50, top: 5),
            child: Text('id комнаты: ${chatRoom.id}', style: TextStyle(fontSize: 20)),
          ),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () async {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => QrCodeView(
                        textForGenerate: UniLinksGenerator().generateJoinChatLink(chatRoom.id),
                      )));
            },
            child: Container(
              width: double.infinity,
              height: 50,
              alignment: Alignment.centerLeft,
              child: Row(
                children: <Widget>[
                  Container(
                      width: 50,
                      height: 50,
                      child: Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                            height: 34,
                            width: 34,
                            child: SvgPicture.asset('assets/icons/ic_qr.svg')),
                      )),
                  Text('Поделиться QR кодом', style: TextStyle(fontSize: 20)),
                ],
              ),
            ),
          ),
        ),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () async {
              // Share.text(chatRoom.name, UniLinksGenerator().generateJoinChatLink(chatRoom.id),
              //     'text/plain');
            },
            child: Container(
              width: double.infinity,
              height: 50,
              alignment: Alignment.centerLeft,
              child: Row(
                children: <Widget>[
                  Container(
                      width: 50,
                      height: 50,
                      child: Align(
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.share,
                          size: 27,
                        ),
                      )),
                  Text('Поделиться ссылкой', style: TextStyle(fontSize: 20)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void onBackButtonPress() => Navigator.of(context).pop();
}
