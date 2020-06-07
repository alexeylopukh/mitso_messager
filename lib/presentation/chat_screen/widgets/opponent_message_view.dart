import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:intl/intl.dart';
import 'package:messager/objects/chat_message.dart';
import 'package:messager/presentation/components/avatar_view.dart';
import 'package:messager/presentation/di/custom_theme.dart';
import 'package:messager/presentation/helper/open_url_helper.dart';

import 'chat_screen_attached_images.dart';

class OpponentMessageView extends StatefulWidget {
  final ChatMessage chatMessage;

  const OpponentMessageView({Key key, this.chatMessage}) : super(key: key);
  @override
  _OpponentMessageViewState createState() => _OpponentMessageViewState();
}

class _OpponentMessageViewState extends State<OpponentMessageView> {
  ChatMessage get chatMessage => widget.chatMessage;
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 10, bottom: 5),
          child: AvatarView(
            avatarKey: chatMessage.sender.avatarUrl,
            name: chatMessage.sender.name,
            size: 45.0,
          ),
        ),
        Flexible(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            margin: EdgeInsets.only(right: 80, top: 5, bottom: 5, left: 5),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: new BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                    bottomLeft: Radius.circular(5),
                    bottomRight: Radius.circular(15)),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xffC7C7C7).withOpacity(0.5),
                    blurRadius: 3.0, // has the effect of softening the shadow
                    spreadRadius: 1.0, // has the effect of extending the shadow
                    offset: Offset(
                      0, // horizontal, move right 10
                      2.0, // vertical, move down 10
                    ),
                  )
                ]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  chatMessage.sender.name.split(' ')[1],
                  style:
                      TextStyle(fontSize: 16, fontFamily: CustomTheme.of(context).boldFontFamily),
                ),
                Container(
                  height: 5,
                  width: 0,
                ),
                Linkify(
                    text: chatMessage.text,
                    style: TextStyle(fontSize: 16),
                    linkStyle: TextStyle(fontSize: 16, color: Color(0xff5AC8FA)),
                    onOpen: (link) {
                      OpenUrlHelper().openUrl(link.url, context);
                    }),
                Container(
                  height: 5,
                  width: 0,
                ),
                if (chatMessage.photos != null && chatMessage.photos.isNotEmpty)
                  ChatScreenAttachedImages(
                    imageKeys: chatMessage.photos,
                  ),
                Text(
                  DateFormat.Hm().format(chatMessage.date),
                  style: TextStyle(fontSize: 12),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
