import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:messager/presentation/chat_rooms_view/chat_rooms_view_model.dart';
import 'package:messager/presentation/chat_rooms_view/widget/chat_room_item_view.dart';
import 'package:messager/presentation/chat_screen/chat_screen.dart';
import 'package:messager/presentation/components/general_scaffold.dart';
import 'package:messager/presentation/di/custom_theme.dart';
import 'package:messager/presentation/di/user_scope_data.dart';

import 'chat_rooms_presenter.dart';

class ChatRoomsView extends StatefulWidget {
  @override
  _ChatRoomsViewState createState() => _ChatRoomsViewState();
}

class _ChatRoomsViewState extends State<ChatRoomsView> {
  ChatRoomsPresenter _presenter;
  @override
  Widget build(BuildContext context) {
    if (_presenter == null) {
      _presenter = ChatRoomsPresenter(UserScopeWidget.of(context));
      UserScopeWidget.of(context).goToChatRoomStream.listen((int roomId) {
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => ChatScreen(
                      roomId: roomId,
                    )));
      });
    }

    return GeneralScaffold(
      child: Column(
        children: <Widget>[
          navBar(),
          StreamBuilder<ChatRoomsViewModel>(
              stream: _presenter.viewModelStream,
              builder: (context, snapshot) {
                ChatRoomsViewModel viewModel = _presenter.viewModelStream.valueWrapper.value;
                if (viewModel.rooms == null) {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(CustomTheme.of(context).primaryColor),
                      strokeWidth: 2.0,
                    ),
                  );
                }
                return Expanded(
                  child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom +
                              MediaQuery.of(context).padding.bottom +
                              55),
                      itemCount: viewModel.rooms.length,
                      itemBuilder: (context, index) {
                        return ChatRoomItemView(
                          chatRoom: viewModel.rooms[index],
                        );
                      }),
                );
              }),
        ],
      ),
    );
  }

  Widget navBar() {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).padding.top + 55,
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 1,
          offset: Offset(0, 1),
        ),
      ]),
      child: Stack(
        fit: StackFit.loose,
        children: <Widget>[
          ClipRRect(
            child: Container(
              height: 55 + MediaQuery.of(context).padding.top,
              color: CustomTheme.of(context).backgroundColor.withOpacity(0.5),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: Center(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: StreamBuilder<bool>(
                        stream: UserScopeWidget.of(context).socketHelper.isSocketConnectionStream,
                        builder: (context, snapshot) {
                          bool isConnected = UserScopeWidget.of(context)
                              .socketHelper
                              .isSocketConnectionStream
                              .valueWrapper
                              .value;
                          return Text(
                            isConnected ? 'Мои чаты' : 'Подключение...',
                            style: TextStyle(
                                color: CustomTheme.of(context).textBlackColor,
                                fontSize: isConnected ? 28 : 24,
                                fontFamily: CustomTheme.of(context).boldFontFamily),
                          );
                        }),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
