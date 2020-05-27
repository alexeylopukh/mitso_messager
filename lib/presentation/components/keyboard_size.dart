import 'package:flutter/material.dart';
import 'package:messager/presentation/di/user_scope_data.dart';
import 'package:provider/provider.dart';

class KeyboardSize extends StatefulWidget {
  final Widget child;
  final UserScopeData userScope;

  KeyboardSize({@required this.child, @required this.userScope})
      : assert(child != null);

  @override
  _KeyboardSizeState createState() => _KeyboardSizeState();
}

class _KeyboardSizeState extends State<KeyboardSize> {
  ScreenHeight _screenHeight;

  @override
  Widget build(BuildContext context) {
    _screenHeight = ScreenHeight(
        initialHeight: MediaQuery.of(context).size.height,
        userScope: widget.userScope,
        initialBottomPadding: MediaQuery.of(context).viewInsets.bottom);
    _screenHeight.change(MediaQuery.of(context).viewInsets.bottom);
    return ChangeNotifierProvider.value(
        value: _screenHeight, child: widget.child);
  }
}

class ScreenHeight extends ChangeNotifier {
  ScreenHeight(
      {@required this.initialHeight,
      @required this.userScope,
      @required this.initialBottomPadding})
      : assert(initialHeight != null);
  final UserScopeData userScope;
  double keyboardHeight = 0;
  double initialHeight;
  final double initialBottomPadding;
  bool get isOpen => keyboardHeight > initialBottomPadding;
  double get screenHeight => initialHeight;

  void change(double a) {
    keyboardHeight = a;
    userScope.keyboardStream
        .add(KeyboardOpenedData(isOpen ? keyboardHeight : 0, isOpen));
    notifyListeners();
  }
}

class KeyboardOpenedData {
  double keyboardHeight = 0;
  bool isOpened;

  KeyboardOpenedData(this.keyboardHeight, this.isOpened);
}
