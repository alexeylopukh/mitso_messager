import 'dart:ui';

import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:messager/objects/chat_message.dart';
import 'package:messager/objects/chat_room.dart';
import 'package:messager/objects/typing_user.dart';
import 'package:messager/presentation/chat_screen/chat_screen_presenter.dart';
import 'package:messager/presentation/chat_screen/chat_screen_view_model.dart';
import 'package:messager/presentation/chat_screen/widgets/opponent_message_view.dart';
import 'package:messager/presentation/chat_screen/widgets/typing_message_widget.dart';
import 'package:messager/presentation/components/avatar_view.dart';
import 'package:messager/presentation/components/general_scaffold.dart';
import 'package:messager/presentation/di/custom_theme.dart';
import 'package:messager/presentation/di/user_scope_data.dart';
import 'package:messager/presentation/helper/ini_links_generator.dart';
import 'package:messager/presentation/qr_code_view/qr_code_view.dart';

import 'widgets/own_message_view.dart';

class ChatScreen extends StatefulWidget {
  final int roomId;

  const ChatScreen({Key key, @required this.roomId}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  ChatScreenPresenter _presenter;
  bool isMenuOpened = false;
  @override
  Widget build(BuildContext context) {
    if (_presenter == null)
      _presenter =
          ChatScreenPresenter(userScope: UserScopeWidget.of(context), roomId: widget.roomId);
    return StreamBuilder<ChatScreenViewModel>(
        stream: _presenter.viewModelSteam,
        builder: (context, snapshot) {
          ChatScreenViewModel viewModel = _presenter.viewModelSteam.value;
          return GeneralScaffold(
            child: Container(
              child: Stack(
                children: <Widget>[
                  Align(child: createMessagesList(viewModel)),
                  Align(alignment: Alignment.bottomCenter, child: inputPanel()),
                  navBar(viewModel.chatRoom),
                ],
              ),
            ),
          );
        });
  }

  Widget navBar(ChatRoom chatRoom) {
    double navBarHeight = MediaQuery.of(context).padding.top + 55;
    double navBarWithMenu = navBarHeight + 100;
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.ease,
      width: double.infinity,
      height: isMenuOpened ? MediaQuery.of(context).size.height : navBarHeight,
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 1,
          offset: Offset(0, 1),
        ),
      ]),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            curve: Curves.ease,
            height: isMenuOpened ? navBarWithMenu : navBarHeight,
            color: CustomTheme.of(context).backgroundColor.withOpacity(0.5),
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
                  navBarMenu(chatRoom),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget navBarMenu(ChatRoom chatRoom) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
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
              Share.text(chatRoom.name, UniLinksGenerator().generateJoinChatLink(chatRoom.id),
                  'text/plain');
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

  Widget inputPanel() {
    double panelHeight = 70.0;
    var borderRadius = BorderRadius.circular(60);
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).viewInsets.bottom + panelHeight,
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 1,
          offset: Offset(0, -1),
        ),
      ]),
      child: Stack(
        fit: StackFit.loose,
        children: <Widget>[
          ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
              child: Container(
                height: MediaQuery.of(context).viewInsets.bottom + panelHeight,
                color: CustomTheme.of(context).backgroundColor.withOpacity(0.5),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: borderRadius,
                ),
                child: Row(
                  children: <Widget>[
                    Flexible(
                      child: Padding(
                          padding: EdgeInsets.only(left: 3),
                          child: TextFormField(
                            controller: _presenter.messageController,
                            textCapitalization: TextCapitalization.sentences,
                            autocorrect: true,
                            enableInteractiveSelection: true,
                            cursorColor: CustomTheme.of(context).primaryColor,
                            decoration: InputDecoration(
                              hintText: 'Введите сообщение',
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              contentPadding:
                                  EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 5),
                            ),
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 0),
                      child: ClipOval(
                        child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                                onTap: _presenter.onSendButtonClick,
                                child: Container(
                                    width: 50,
                                    height: 50,
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: SizedBox(
                                          height: 24,
                                          width: 24,
                                          child: SvgPicture.asset('assets/icons/ic_send.svg')),
                                    )))),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget createMessagesList(ChatScreenViewModel viewModel) {
    List<ChatMessage> messages = [];
    messages.addAll(viewModel.unsendedMessages);
    messages.addAll(viewModel.chatRoom.messages);
    return ScrollConfiguration(
      behavior: ScrollBehavior(),
      child: ListView.builder(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 55,
          bottom: MediaQuery.of(context).viewInsets.bottom + 65,
        ),
        reverse: true,
        itemCount: messages.length + 1,
        itemBuilder: (context, index) {
          if (index == 0)
            return StreamBuilder<TypingUser>(
                stream: UserScopeWidget.of(context).socketInteractor.typingUsersStream,
                builder: (context, snapshot) {
                  TypingUser typingUser = snapshot.data;
                  if (typingUser != null &&
                      (!typingUser.isTyping || typingUser.roomId != _presenter.roomId))
                    typingUser = null;
                  return TypingMessageWidget(
                    typingUser: typingUser,
                  );
                });
          if (messages[index - 1].sender.id == UserScopeWidget.of(context).myProfile.id)
            return OwnMessageView(
              chatMessage: messages[index - 1],
            );
          return OpponentMessageView(
            chatMessage: messages[index - 1],
          );
        },
      ),
    );
  }

  onBackButtonPress() => Navigator.of(context).pop();
}
