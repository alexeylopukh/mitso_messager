import 'package:flutter/material.dart';
import 'package:messager/presentation/di/custom_theme.dart';

import 'custom_elevation.dart';

class CustomButton extends StatelessWidget {
  final double height;
  final double width;
  final Widget child;
  final Function onTap;

  const CustomButton(
      {Key key,
      @required this.height,
      @required this.width,
      @required this.child,
      @required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomElevation(
      height: height,
      child: Material(
        color: CustomTheme.of(context).primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(8.0),
        ),
        child: InkWell(
          child: Container(
            height: height,
            width: width,
            child: Center(
              child: child,
            ),
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}
