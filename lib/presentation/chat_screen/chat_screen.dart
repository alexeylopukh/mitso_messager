import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:messager/objects/typing_user.dart';
import 'package:messager/objects/upload_image.dart';
import 'package:messager/presentation/chat_screen/chat_screen_presenter.dart';
import 'package:messager/presentation/chat_screen/chat_screen_view_model.dart';
import 'package:messager/presentation/chat_screen/widgets/attach_file_popup.dart';
import 'package:messager/presentation/chat_screen/widgets/chat_screen_appbar.dart';
import 'package:messager/presentation/chat_screen/widgets/opponent_message_view.dart';
import 'package:messager/presentation/chat_screen/widgets/own_message_view.dart';
import 'package:messager/presentation/chat_screen/widgets/typing_message_widget.dart';
import 'package:messager/presentation/chat_screen/widgets/upload_image_item.dart';
import 'package:messager/presentation/components/button_icon.dart';
import 'package:messager/presentation/components/general_scaffold.dart';
import 'package:messager/presentation/di/custom_theme.dart';
import 'package:messager/presentation/di/user_scope_data.dart';

class ChatScreen extends StatefulWidget {
  final int roomId;

  const ChatScreen({Key key, @required this.roomId}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  ChatScreenPresenter _presenter;

  @override
  Widget build(BuildContext context) {
    if (_presenter == null) {
      _presenter =
          ChatScreenPresenter(userScope: UserScopeWidget.of(context), roomId: widget.roomId);
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        _presenter.screenIsBuilded = true;
      });
    }
    return GeneralScaffold(
      child: StreamBuilder<ChatScreenViewModel>(
          stream: _presenter.viewModelSteam,
          builder: (context, snapshot) {
            ChatScreenViewModel viewModel = _presenter.viewModel;
            return Stack(
              children: <Widget>[
                ListView.builder(
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + 55,
                    bottom: MediaQuery.of(context).viewInsets.bottom +
                        MediaQuery.of(context).padding.bottom +
                        65,
                  ),
                  reverse: true,
                  itemCount: _presenter.viewModel.messages.length,
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
                    if (index == _presenter.viewModel.messages.length &&
                        _presenter.viewModel.messages.isNotEmpty &&
                        _presenter.viewModel.messages.length > 45) _presenter.loadChatHistory();
                    if (_presenter.viewModel.messages[index - 1].sender.id ==
                        UserScopeWidget.of(context).myProfile.id)
                      return OwnMessageView(
                        chatMessage: _presenter.viewModel.messages[index - 1],
                      );
                    return OpponentMessageView(
                      chatMessage: _presenter.viewModel.messages[index - 1],
                    );
                  },
                ),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: StreamBuilder<List<UploadImage>>(
                        stream: _presenter.uploadImagesStream.stream,
                        builder: (context, snapshot) {
                          double panelHeight = 70.0 + MediaQuery.of(context).padding.bottom;
                          if (_presenter.uploadImages.isNotEmpty) {
                            panelHeight += 50;
                          }
                          return Container(
                            width: double.infinity,
                            height: MediaQuery.of(context).viewInsets.bottom + panelHeight,
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
                                  bottom: MediaQuery.of(context).padding.bottom +
                                      MediaQuery.of(context).viewInsets.bottom),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  uploadImagePanel(_presenter.uploadImages),
                                  Row(
                                    children: <Widget>[
                                      Container(
                                        width: 5,
                                      ),
                                      ButtonIcon(
                                        size: 40,
                                        iconSize: 40,
                                        onClick: () async {
                                          PickedFiles pickedFiles =
                                              await showAttachFilePopup(context);
                                          if (pickedFiles != null && pickedFiles.files.isNotEmpty)
                                            _presenter.uploadFiles(pickedFiles);
                                        },
                                        image: 'assets/icons/ic_attach.svg',
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding:
                                              EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(60),
                                            ),
                                            child: Row(
                                              children: <Widget>[
                                                Flexible(
                                                  child: Padding(
                                                      padding: EdgeInsets.only(left: 3),
                                                      child: TextFormField(
                                                        controller: _presenter.messageController,
                                                        textCapitalization:
                                                            TextCapitalization.sentences,
                                                        autocorrect: true,
                                                        enableInteractiveSelection: true,
                                                        cursorColor:
                                                            CustomTheme.of(context).primaryColor,
                                                        decoration: InputDecoration(
                                                          hintText: 'Введите сообщение',
                                                          border: InputBorder.none,
                                                          focusedBorder: InputBorder.none,
                                                          enabledBorder: InputBorder.none,
                                                          errorBorder: InputBorder.none,
                                                          disabledBorder: InputBorder.none,
                                                          contentPadding: EdgeInsets.only(
                                                              left: 15,
                                                              bottom: 11,
                                                              top: 11,
                                                              right: 5),
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
                                                                      child: SvgPicture.asset(
                                                                          'assets/icons/ic_send.svg')),
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
                                ],
                              ),
                            ),
                          );
                        })),
                ChatScreenAppBar(chatRoom: viewModel.chatRoom),
              ],
            );
          }),
    );
  }

  Widget uploadImagePanel(List<UploadImage> images) {
    if (images?.isEmpty ?? true) return Container();
    return SizedBox(
      height: 50,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: images.length,
          itemBuilder: (context, index) => UploadImageItem(
                uploadImage: images[index],
              )),
    );
  }
}
