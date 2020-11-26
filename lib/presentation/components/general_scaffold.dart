import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:messager/presentation/di/custom_theme.dart';

class GeneralScaffold extends StatelessWidget {
  final Widget child;
  final bool addNavBarPadding;
  final Color backgroundColor;

  const GeneralScaffold(
      {Key key, @required this.child, this.addNavBarPadding = false, this.backgroundColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
        SystemChannels.textInput.invokeMethod('TextInput.hide');
      },
      child: Material(
        color: backgroundColor ?? CustomTheme.of(context).backgroundColor,
        child: Padding(
          padding: EdgeInsets.only(
              bottom: addNavBarPadding ? MediaQuery.of(context).viewInsets.bottom : 0),
          child: child,
        ),
      ),
    );
  }
}
