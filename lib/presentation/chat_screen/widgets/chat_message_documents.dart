import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:messager/interactor/open_document.dart';
import 'package:messager/objects/chat_message.dart';
import 'package:messager/objects/chat_message_image.dart';
import 'package:messager/presentation/di/custom_theme.dart';
import 'package:messager/presentation/di/user_scope_data.dart';

class ChatMessageDocuments extends StatefulWidget {
  final ChatMessage chatMessage;
  const ChatMessageDocuments(
    this.chatMessage, {
    Key key,
  }) : super(key: key);

  @override
  _ChatMessageDocumentsState createState() => _ChatMessageDocumentsState();
}

class _ChatMessageDocumentsState extends State<ChatMessageDocuments> {
  ChatMessage get chatMessage => widget.chatMessage;
  List<ChatMessageDocument> get docs => chatMessage.files;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
          docs.length,
          (index) => _DocumentView(
              docs[index], chatMessage.sender.id == UserScopeWidget.of(context).myProfile.id)),
    );
  }
}

class _DocumentView extends StatefulWidget {
  final ChatMessageDocument document;
  final bool ownMessage;

  const _DocumentView(this.document, this.ownMessage, {Key key}) : super(key: key);

  @override
  __DocumentViewState createState() => __DocumentViewState();
}

class __DocumentViewState extends State<_DocumentView> {
  ChatMessageDocument get document => widget.document;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      child: InkWell(
        onTap: () {
          OpenDocument(context).open(document);
        },
        child: Row(
          children: [
            if (!widget.ownMessage)
              ClipOval(
                  child: Container(
                height: 40,
                width: 40,
                color: CustomTheme.of(context).primaryColor,
                alignment: Alignment.center,
                child: Icon(
                  Icons.insert_drive_file,
                  color: Colors.white,
                ),
              )),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Text(
                document.fileName ?? "null",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                  color: CustomTheme.of(context).textBlackColor,
                ),
                textAlign: widget.ownMessage ? TextAlign.end : TextAlign.start,
              ),
            )),
            if (widget.ownMessage)
              ClipOval(
                  child: Container(
                height: 40,
                width: 40,
                color: CustomTheme.of(context).primaryColor,
                alignment: Alignment.center,
                child: Icon(
                  Icons.insert_drive_file,
                  color: Colors.white,
                ),
              )),
          ],
        ),
      ),
    );
  }
}
