import 'package:flutter/material.dart';
import 'package:messager/presentation/components/custom_elevation.dart';
import 'package:messager/presentation/di/custom_theme.dart';

class NewsFab extends StatefulWidget {
  final double size;
  final Function onTab;

  const NewsFab({Key key, this.size = 55, @required this.onTab}) : super(key: key);

  @override
  _NewsFabState createState() => _NewsFabState();
}

class _NewsFabState extends State<NewsFab> {
  @override
  Widget build(BuildContext context) {
    return CustomElevation(
      height: widget.size,
      child: ClipOval(
        child: Container(
          width: widget.size,
          height: widget.size,
          color: CustomTheme.of(context).primaryColor,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.onTab,
              child: Center(
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: widget.size / 1.6,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
