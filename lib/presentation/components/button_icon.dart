import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ButtonIcon extends StatefulWidget {
  final Function onClick;
  final double size;
  final double iconSize;
  final String image;

  const ButtonIcon(
      {Key key, @required this.onClick, @required this.size, @required this.image, this.iconSize})
      : super(key: key);
  @override
  _ButtonIconState createState() => _ButtonIconState();
}

class _ButtonIconState extends State<ButtonIcon> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: widget.size,
        width: widget.size,
        child: Stack(
          children: <Widget>[
            Center(
              child: SizedBox(
                  height: widget.iconSize ?? widget.size,
                  width: widget.iconSize ?? widget.size,
                  child: SvgPicture.asset(widget.image)),
            ),
            ClipOval(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: widget.onClick,
                  child: Container(
                    height: widget.size,
                    width: widget.size,
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
