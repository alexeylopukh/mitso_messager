import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:messager/constants.dart';
import 'package:messager/presentation/di/custom_theme.dart';

class AvatarView extends StatefulWidget {
  final double size;
  final String avatarKey;
  final String name;

  const AvatarView(
      {Key key,
      @required this.size,
      @required this.avatarKey,
      @required this.name})
      : super(key: key);
  @override
  _AvatarViewState createState() => _AvatarViewState();
}

class _AvatarViewState extends State<AvatarView> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: widget.avatarKey == null
              ? CustomTheme.of(context).primaryColor
              : Colors.black.withOpacity(0.2),
          image: widget.avatarKey == null
              ? null
              : DecorationImage(
                  fit: BoxFit.cover,
                  image: CachedNetworkImageProvider(
                      API_URL + '/' + widget.avatarKey),
                ),
        ),
        child: widget.avatarKey == null
            ? Center(
                child: Text(
                  widget.name.split('').first.toUpperCase(),
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: CustomTheme.of(context).boldFontFamily,
                      fontSize: widget.size / 2),
                ),
              )
            : null,
      ),
    );
  }
}
