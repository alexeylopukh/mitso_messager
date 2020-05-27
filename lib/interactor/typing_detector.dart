import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

class TypingDetector {
  final Function onStartTyping;
  final Function onStopTyping;
  final TextEditingController textEditingController;
  final PublishSubject<String> _typingStream = PublishSubject<String>();
  Duration duration;
  bool isTyping = false;

  TypingDetector(
      {@required this.onStartTyping,
      @required this.onStopTyping,
      @required this.textEditingController,
      this.duration}) {
    if (duration == null) duration = Duration(milliseconds: 1000);
    textEditingController.addListener(() {
      if (textEditingController?.text != null &&
          textEditingController.text != "")
        _typingStream.add(textEditingController.text);
    });
    _typingStream.throttleTime(duration).listen((_) {
      if (!isTyping) {
        onStartTyping();
        isTyping = true;
      }
    });
    _typingStream.debounceTime(duration).listen((_) {
      if (isTyping) {
        onStopTyping();
        isTyping = false;
      }
    });
  }

  dispose() {
    _typingStream?.close();
  }
}
