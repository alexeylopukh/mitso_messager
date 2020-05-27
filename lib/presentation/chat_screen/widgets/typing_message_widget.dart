import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controls.dart';
import 'package:flutter/material.dart';
import 'package:messager/objects/typing_user.dart';

class TypingMessageWidget extends StatefulWidget {
  final TypingUser typingUser;

  const TypingMessageWidget({Key key, @required this.typingUser})
      : super(key: key);
  @override
  _TypingMessageWidgetState createState() => _TypingMessageWidgetState();
}

class _TypingMessageWidgetState extends State<TypingMessageWidget> {
  final FlareControls controls = FlareControls();
  TypingUser get typingUser => widget.typingUser;
  TypingUser lastUser;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: EdgeInsets.only(left: 60),
      child: FlareActor(
        "assets/animations/typing_message.flr",
        alignment: Alignment.bottomLeft,
        fit: BoxFit.contain,
        animation: animationName(),
        controller: controls,
      ),
    );
  }

  String animationName() {
    String animation;
    if (lastUser == null && typingUser == null)
      animation = 'idle';
    else if (lastUser == null && typingUser != null) {
      Future.delayed(Duration(milliseconds: 100)).then((_) {
        controls.play('typing');
      });
      animation = 'start';
    } else if (lastUser != null && typingUser == null)
      animation = 'stop';
    else
      animation = 'typing';
    lastUser = typingUser;
    return animation;
  }
}
