import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:messager/objects/call_request.dart';
import 'package:messager/presentation/di/user_scope_data.dart';
import 'package:messager/presentation/live_video_chat_screen/live_chat_call_screen.dart';

import '../constants.dart';

class CallScreen extends StatefulWidget {
  final CallRequest callRequest;

  const CallScreen({Key key, @required this.callRequest}) : super(key: key);

  @override
  _CallScreenState createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      child: Stack(
        children: [
          if (widget.callRequest.profile.avatarUrl != null &&
              widget.callRequest.profile.avatarUrl.isNotEmpty)
            Container(
              decoration: new BoxDecoration(
                image: new DecorationImage(
                  image: CachedNetworkImageProvider(
                      API_URL + "/" + widget.callRequest.profile.avatarUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          Center(
            child: Text(
              widget.callRequest.profile.name,
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 40),
              child: Row(
                children: [
                  RawMaterialButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.call_end,
                      color: Colors.white,
                      size: 35.0,
                    ),
                    shape: CircleBorder(),
                    elevation: 2.0,
                    fillColor: Colors.redAccent,
                    padding: const EdgeInsets.all(15.0),
                  ),
                  Spacer(),
                  RawMaterialButton(
                    onPressed: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) {
                        return CallPage(
                          role: ClientRole.Broadcaster,
                          channelName: UserScopeWidget.of(context).myProfile.id.toString(),
                          token: widget.callRequest.token,
                        );
                      }));
                    },
                    child: Icon(
                      Icons.call_rounded,
                      color: Colors.white,
                      size: 35.0,
                    ),
                    shape: CircleBorder(),
                    elevation: 2.0,
                    fillColor: Colors.green,
                    padding: const EdgeInsets.all(15.0),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
