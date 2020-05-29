import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:messager/objects/news_model.dart';
import 'package:messager/presentation/di/custom_theme.dart';
import 'package:messager/presentation/helper/open_url_helper.dart';

class NewsItemWidget extends StatefulWidget {
  final NewsModel newsModel;

  const NewsItemWidget({Key key, @required this.newsModel}) : super(key: key);
  @override
  _NewsItemWidgetState createState() => _NewsItemWidgetState();
}

class _NewsItemWidgetState extends State<NewsItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: new BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15)),
            boxShadow: [
              BoxShadow(
                color: Color(0xffC7C7C7).withOpacity(0.5),
                blurRadius: 3.0, // has the effect of softening the shadow
                spreadRadius: 1.0, // has the effect of extending the shadow
                offset: Offset(
                  0, // horizontal, move right 10
                  2.0, // vertical, move down 10
                ),
              )
            ]),
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                widget.newsModel.title,
                style: TextStyle(fontSize: 18, fontFamily: CustomTheme.of(context).boldFontFamily),
              ),
              Linkify(
                text: widget.newsModel.text,
                style: TextStyle(fontSize: 16),
                linkStyle: TextStyle(fontSize: 16, color: Color(0xff5AC8FA)),
                onOpen: (link) {
                  OpenUrlHelper().openUrl(link.url, context);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
