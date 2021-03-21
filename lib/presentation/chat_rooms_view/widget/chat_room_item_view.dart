import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:messager/objects/chat_room.dart';
import 'package:messager/presentation/chat_screen/chat_screen.dart';
import 'package:messager/presentation/components/avatar_view.dart';
import 'package:messager/presentation/di/custom_theme.dart';
import 'package:messager/presentation/helper/date_helper.dart';

class ChatRoomItemView extends StatefulWidget {
  final ChatRoom chatRoom;

  const ChatRoomItemView({Key key, @required this.chatRoom}) : super(key: key);
  @override
  _ChatRoomItemViewState createState() => _ChatRoomItemViewState();
}

class _ChatRoomItemViewState extends State<ChatRoomItemView> {
  ChatRoom get chatRoom => widget.chatRoom;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => ChatScreen(
                            roomId: chatRoom.id,
                          )));
            },
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Container(
                child: Row(
                  children: <Widget>[
                    Hero(
                      tag: chatRoom.id,
                      child: AvatarView(
                        avatarKey: chatRoom.imageKey,
                        name: chatRoom.name,
                        size: 50.0,
                      ),
                    ),
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
                          if (chatRoom.messages.isNotEmpty)
                            RichText(
                              maxLines: 2,
                              softWrap: false,
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(children: [
                                TextSpan(
                                  text: chatRoom.messages.first.sender.name.split(' ').first + ": ",
                                  style: TextStyle(
                                      color: CustomTheme.of(context).textBlackGrayColor,
                                      fontSize: 16,
                                      fontFamily: CustomTheme.of(context).boldFontFamily),
                                ),
                                TextSpan(
                                  text: chatRoom.messages.first.encryptedMessage,
                                  style: TextStyle(
                                      color: CustomTheme.of(context).textBlackGrayColor,
                                      fontSize: 16),
                                )
                              ]),
                            ),
                        ],
                      ),
                    ),
                    Container(
                      width: 5,
                    ),
                    if (chatRoom.messages.isNotEmpty)
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text(composeAgoTime(chatRoom.messages.first.date),
                              style: TextStyle(
                                  color: CustomTheme.of(context).textBlackGrayColor, fontSize: 12))
                        ],
                      )
                  ],
                ),
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 80),
          width: double.infinity,
          height: 1,
          color: Colors.black.withOpacity(0.1),
        )
      ],
    );
  }
}
