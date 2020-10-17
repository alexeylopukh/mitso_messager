import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:intl/intl.dart';
import 'package:messager/objects/chat_message.dart';
import 'package:messager/presentation/di/custom_theme.dart';
import 'package:messager/presentation/helper/open_url_helper.dart';

import 'chat_screen_attached_images.dart';

class OwnMessageView extends StatefulWidget {
  final ChatMessage chatMessage;

  const OwnMessageView({Key key, this.chatMessage}) : super(key: key);
  @override
  _OwnMessageViewState createState() => _OwnMessageViewState();
}

class _OwnMessageViewState extends State<OwnMessageView> {
  ChatMessage get chatMessage => widget.chatMessage;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              margin: EdgeInsets.only(right: 10, top: 5, bottom: 5, left: 80),
              decoration: BoxDecoration(
                  color: CustomTheme.of(context).primaryColor,
                  borderRadius: new BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                      bottomRight: Radius.circular(5),
                      bottomLeft: Radius.circular(15)),
                  boxShadow: [
                    BoxShadow(
                      color: CustomTheme.of(context).primaryColor.withOpacity(0.5),
                      blurRadius: 3.0, // has the effect of softening the shadow
                      spreadRadius: 1.0, // has the effect of extending the shadow
                      offset: Offset(
                        0, // horizontal, move right 10
                        2.0, // vertical, move down 10
                      ),
                    )
                  ]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  SelectableLinkify(
                    text: chatMessage.text,
                    style: TextStyle(fontSize: 16, color: Colors.white),
                    linkStyle: TextStyle(fontSize: 16, color: Color(0xff002940)),
                    onOpen: (link) {
                      OpenUrlHelper().openUrl(link.url, context);
                    },
                  ),
                  Container(
                    height: 5,
                    width: 0,
                  ),
                  if (chatMessage.photos != null && chatMessage.photos.isNotEmpty)
                    ChatScreenAttachedImages(
                      imageKeys: chatMessage.photos,
                    ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        DateFormat.Hm().format(chatMessage.date),
                        style: TextStyle(
                          fontSize: 12,
                          color: CustomTheme.of(context).backgroundColor,
                        ),
                      ),
                      if (!chatMessage.isSended)
                        Padding(
                          padding: const EdgeInsets.only(left: 3),
                          child: Icon(Icons.access_time,
                              size: 12, color: CustomTheme.of(context).backgroundColor),
                        )
                      else
                        Padding(
                          padding: const EdgeInsets.only(left: 3),
                          child: Icon(Icons.done,
                              size: 12, color: CustomTheme.of(context).backgroundColor),
                        )
                    ],
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
