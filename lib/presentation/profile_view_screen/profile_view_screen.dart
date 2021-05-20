import 'dart:async';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:messager/interactor/encrypt_interactor.dart';
import 'package:messager/network/rpc/generate_agora_token_rpc.dart';
import 'package:messager/objects/chat_room.dart';
import 'package:messager/objects/profile.dart';
import 'package:messager/presentation/components/avatar_view.dart';
import 'package:messager/presentation/components/custom_button.dart';
import 'package:messager/presentation/components/general_scaffold.dart';
import 'package:messager/presentation/di/custom_theme.dart';
import 'package:messager/presentation/di/user_scope_data.dart';
import 'package:messager/presentation/live_video_chat_screen/live_chat_call_screen.dart';

class ProfileViewScreen extends StatefulWidget {
  final Profile profile;

  const ProfileViewScreen({Key key, @required this.profile}) : super(key: key);

  @override
  _ProfileViewScreenState createState() => _ProfileViewScreenState();
}

class _ProfileViewScreenState extends State<ProfileViewScreen> {
  Profile get profile => widget.profile;

  @override
  Widget build(BuildContext context) {
    return GeneralScaffold(
        child: Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).viewInsets.top + MediaQuery.of(context).padding.top),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(
                  icon: Icon(Icons.arrow_back_ios_rounded),
                  onPressed: () {
                    Navigator.of(context).pop();
                  })
            ],
          ),
        ),
        Spacer(),
        Padding(
          padding: const EdgeInsets.only(bottom: 25),
          child: GestureDetector(
            onTap: () {},
            child: AvatarView(
                size: MediaQuery.of(context).size.width - 100,
                avatarKey: profile.avatarUrl,
                name: profile.name),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Text(
            profile.name,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: CustomTheme.of(context).textBlackGrayColor,
                fontFamily: CustomTheme.of(context).boldFontFamily,
                fontSize: 24),
          ),
        ),
        Container(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomButton(
                height: 56,
                width: 100,
                child: Text(
                  'Личное сообщение',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
                onTap: () async {
                  List<ChatRoom> chatRooms =
                      await UserScopeWidget.of(context).roomsLocalStore.get();
                  if (chatRooms != null) {
                    ChatRoom chatRoom;
                    try {
                      chatRoom = chatRooms.firstWhere((element) {
                        return profile.email == element?.user?.email;
                      });
                    } catch (e) {}
                    if (chatRoom != null) {
                      UserScopeWidget.of(context).goToChatRoomStream.add(chatRoom.id);
                      return;
                    }
                  }
                  var socket = UserScopeWidget.of(context).socketHelper;
                  socket.sendData('on_create_room', {
                    'room_name': "direct",
                    'thumb_image_key': "",
                    'private_key':
                        EncryptInteractor(UserScopeWidget.of(context)).generateRandomKey(),
                    'user_id': profile.id,
                    'is_direct': true,
                  });
                  socket.createRoomCompleter = Completer();
                  bool result = await socket.createRoomCompleter.future
                      .timeout(Duration(seconds: 3))
                      .catchError((e) {
                    //ignore
                  });
                  chatRooms = await UserScopeWidget.of(context).roomsLocalStore.get();
                  if (chatRooms != null) {
                    ChatRoom chatRoom;
                    try {
                      chatRoom = chatRooms.firstWhere((element) {
                        return profile.email == element?.user?.email;
                      });
                    } catch (e) {}
                    if (chatRoom != null) {
                      UserScopeWidget.of(context).goToChatRoomStream.add(chatRoom.id);
                      return;
                    }
                  }
                }),
            Container(
              width: 10,
            ),
            CustomButton(
                height: 56,
                width: 100,
                child: Text(
                  'Позвонить',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
                onTap: () async {
                  String token = await GenerateAgoraToken(UserScopeWidget.of(context))
                      .generateToken(profile.id.toString());
                  UserScopeWidget.of(context).socketHelper.sendData("call_request", {
                    "agora_room": token,
                    "user_id": [profile.id]
                  });

                  Navigator.of(context).push(MaterialPageRoute(builder: (c) {
                    return CallPage(
                      role: ClientRole.Broadcaster,
                      channelName: profile.id.toString(),
                      token: token,
                    );
                  }));
                }),
          ],
        ),
        Spacer(),
      ],
    ));
  }
}
