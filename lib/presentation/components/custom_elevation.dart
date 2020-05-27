import 'package:flutter/material.dart';
import 'package:messager/presentation/di/custom_theme.dart';

class CustomElevation extends StatelessWidget {
  final Widget child;
  final double height;
  final Color color;

  CustomElevation({@required this.child, @required this.height, this.color})
      : assert(child != null);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: this.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(this.height / 2)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: color == null
                ? CustomTheme.of(context).primaryColor.withOpacity(0.2)
                : color.withOpacity(0.2),
            blurRadius: height / 5,
            offset: Offset(0, height / 5),
          ),
        ],
      ),
      child: this.child,
    );
  }
}
