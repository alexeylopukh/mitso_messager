import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';

class ChatScreenAttachedImages extends StatefulWidget {
  final List<String> imageKeys;

  const ChatScreenAttachedImages({Key key, @required this.imageKeys}) : super(key: key);

  @override
  _ChatScreenAttachedImagesState createState() => _ChatScreenAttachedImagesState();
}

class _ChatScreenAttachedImagesState extends State<ChatScreenAttachedImages> {
  List<String> get imageKeys => widget.imageKeys;
  double width;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 5),
      child: LayoutBuilder(builder: (context, c) {
        width = c.maxWidth - 4;
        switch (imageKeys.length) {
          case 1:
            return layout1();
          case 2:
            return layout2();
          case 3:
            return layout3();
          case 4:
            return layout4();
          case 5:
            return layout5();
          case 6:
            return layout6();
          case 7:
            return layout7();
          case 8:
            return layout8();
          case 9:
            return layout9();
          default:
            return layout10();
        }
      }),
    );
  }

  Widget layout1() {
    return createContainer(width, imageKeys[0]);
  }

  Widget layout2() {
    return Row(
      children: <Widget>[
        createContainer(width / 2, imageKeys[0]),
        createContainer(width / 2, imageKeys[1]),
      ],
    );
  }

  Widget layout3() {
    return Column(
      children: <Widget>[
        createContainer(width, imageKeys[0]),
        Row(
          children: <Widget>[
            createContainer(width / 2, imageKeys[1]),
            createContainer(width / 2, imageKeys[2]),
          ],
        ),
      ],
    );
  }

  Widget layout4() {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            createContainer(width / 2, imageKeys[0]),
            createContainer(width / 2, imageKeys[1]),
          ],
        ),
        Row(
          children: <Widget>[
            createContainer(width / 2, imageKeys[2]),
            createContainer(width / 2, imageKeys[3]),
          ],
        ),
      ],
    );
  }

  Widget layout5() {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            createContainer(width / 2, imageKeys[0]),
            createContainer(width / 2, imageKeys[1]),
          ],
        ),
        Row(
          children: <Widget>[
            createContainer(width / 3, imageKeys[2]),
            createContainer(width / 3, imageKeys[3]),
            createContainer(width / 3, imageKeys[4])
          ],
        ),
      ],
    );
  }

  Widget layout6() {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            createContainer(width / 3, imageKeys[0]),
            createContainer(width / 3, imageKeys[1]),
            createContainer(width / 3, imageKeys[2]),
          ],
        ),
        Row(
          children: <Widget>[
            createContainer(width / 3, imageKeys[3]),
            createContainer(width / 3, imageKeys[4]),
            createContainer(width / 3, imageKeys[5]),
          ],
        ),
      ],
    );
  }

  Widget layout7() {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            createContainer(width / 2, imageKeys[0]),
            createContainer(width / 2, imageKeys[1]),
          ],
        ),
        Row(
          children: <Widget>[
            createContainer(width / 2, imageKeys[2]),
            createContainer(width / 2, imageKeys[3]),
          ],
        ),
        Row(
          children: <Widget>[
            createContainer(width / 3, imageKeys[4]),
            createContainer(width / 3, imageKeys[5]),
            createContainer(width / 3, imageKeys[6]),
          ],
        ),
      ],
    );
  }

  Widget layout8() {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            createContainer(width / 2, imageKeys[0]),
            createContainer(width / 2, imageKeys[1]),
          ],
        ),
        Row(
          children: <Widget>[
            createContainer(width / 3, imageKeys[2]),
            createContainer(width / 3, imageKeys[3]),
            createContainer(width / 3, imageKeys[4]),
          ],
        ),
        Row(
          children: <Widget>[
            createContainer(width / 3, imageKeys[5]),
            createContainer(width / 3, imageKeys[6]),
            createContainer(width / 3, imageKeys[7]),
          ],
        ),
      ],
    );
  }

  Widget layout9() {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            createContainer(width / 3, imageKeys[0]),
            createContainer(width / 3, imageKeys[1]),
            createContainer(width / 3, imageKeys[2]),
          ],
        ),
        Row(
          children: <Widget>[
            createContainer(width / 3, imageKeys[3]),
            createContainer(width / 3, imageKeys[4]),
            createContainer(width / 3, imageKeys[5]),
          ],
        ),
        Row(
          children: <Widget>[
            createContainer(width / 3, imageKeys[6]),
            createContainer(width / 3, imageKeys[7]),
            createContainer(width / 3, imageKeys[8]),
          ],
        ),
      ],
    );
  }

  Widget layout10() {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            createContainer(
              width / 3,
              imageKeys[0],
            ),
            createContainer(
              width / 3,
              imageKeys[1],
            ),
            createContainer(
              width / 3,
              imageKeys[2],
            ),
          ],
        ),
        Row(
          children: <Widget>[
            createContainer(
              width / 3,
              imageKeys[3],
            ),
            createContainer(
              width / 3,
              imageKeys[4],
            ),
            createContainer(
              width / 3,
              imageKeys[5],
            ),
          ],
        ),
        Row(
          children: <Widget>[
            createContainer(
              width / 4,
              imageKeys[6],
            ),
            createContainer(
              width / 4,
              imageKeys[7],
            ),
            createContainer(
              width / 4,
              imageKeys[8],
            ),
            createContainer(
              width / 4,
              imageKeys[9],
            )
          ],
        ),
      ],
    );
  }

  Widget createContainer(double width, String url) {
    return Padding(
      padding: EdgeInsets.all(0.5),
      child: Container(
        width: width,
        height: width,
        decoration: decoration(url),
      ),
    );
  }

  BoxDecoration decoration(String key) {
    return BoxDecoration(
        image: key == null
            ? null
            : DecorationImage(
                fit: BoxFit.cover,
                image: CachedNetworkImageProvider(API_URL + '/' + key),
              ));
  }
}