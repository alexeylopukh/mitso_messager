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
    return LayoutBuilder(builder: (context, c) {
      width = c.maxWidth;
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
    });
  }

  Widget layout1() {
    return Container(
      width: width,
      decoration: decoration(imageKeys[0]),
    );
  }

  Widget layout2() {
    return Row(
      children: <Widget>[
        Container(
          width: width / 2,
          height: width / 2,
          decoration: decoration(imageKeys[0]),
        ),
        Container(
          width: width / 2,
          height: width / 2,
          decoration: decoration(imageKeys[1]),
        )
      ],
    );
  }

  Widget layout3() {
    return Column(
      children: <Widget>[
        Container(
          width: width,
          decoration: decoration(imageKeys[0]),
        ),
        Row(
          children: <Widget>[
            Container(
              width: width / 2,
              decoration: decoration(imageKeys[1]),
            ),
            Container(
              width: width / 2,
              decoration: decoration(imageKeys[2]),
            )
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
            Container(
              width: width / 2,
              decoration: decoration(imageKeys[0]),
            ),
            Container(
              width: width / 2,
              decoration: decoration(imageKeys[1]),
            )
          ],
        ),
        Row(
          children: <Widget>[
            Container(
              width: width / 2,
              decoration: decoration(imageKeys[2]),
            ),
            Container(
              width: width / 2,
              decoration: decoration(imageKeys[3]),
            )
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
            Container(
              width: width / 2,
              decoration: decoration(imageKeys[0]),
            ),
            Container(
              width: width / 2,
              decoration: decoration(imageKeys[1]),
            )
          ],
        ),
        Row(
          children: <Widget>[
            Container(
              width: width / 3,
              decoration: decoration(imageKeys[2]),
            ),
            Container(
              width: width / 3,
              decoration: decoration(imageKeys[3]),
            ),
            Container(
              width: width / 3,
              decoration: decoration(imageKeys[4]),
            )
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
            Container(
              width: width / 3,
              decoration: decoration(imageKeys[0]),
            ),
            Container(
              width: width / 3,
              decoration: decoration(imageKeys[1]),
            ),
            Container(
              width: width / 3,
              decoration: decoration(imageKeys[2]),
            )
          ],
        ),
        Row(
          children: <Widget>[
            Container(
              width: width / 3,
              decoration: decoration(imageKeys[3]),
            ),
            Container(
              width: width / 3,
              decoration: decoration(imageKeys[4]),
            ),
            Container(
              width: width / 3,
              decoration: decoration(imageKeys[5]),
            ),
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
            Container(
              width: width / 2,
              decoration: decoration(imageKeys[0]),
            ),
            Container(
              width: width / 2,
              decoration: decoration(imageKeys[1]),
            )
          ],
        ),
        Row(
          children: <Widget>[
            Container(
              width: width / 2,
              decoration: decoration(imageKeys[2]),
            ),
            Container(
              width: width / 2,
              decoration: decoration(imageKeys[3]),
            )
          ],
        ),
        Row(
          children: <Widget>[
            Container(
              width: width / 3,
              decoration: decoration(imageKeys[4]),
            ),
            Container(
              width: width / 3,
              decoration: decoration(imageKeys[5]),
            ),
            Container(
              width: width / 3,
              decoration: decoration(imageKeys[6]),
            )
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
            Container(
              width: width / 2,
              decoration: decoration(imageKeys[0]),
            ),
            Container(
              width: width / 2,
              decoration: decoration(imageKeys[1]),
            )
          ],
        ),
        Row(
          children: <Widget>[
            Container(
              width: width / 3,
              decoration: decoration(imageKeys[2]),
            ),
            Container(
              width: width / 3,
              decoration: decoration(imageKeys[3]),
            ),
            Container(
              width: width / 3,
              decoration: decoration(imageKeys[4]),
            )
          ],
        ),
        Row(
          children: <Widget>[
            Container(
              width: width / 3,
              decoration: decoration(imageKeys[5]),
            ),
            Container(
              width: width / 3,
              decoration: decoration(imageKeys[6]),
            ),
            Container(
              width: width / 3,
              decoration: decoration(imageKeys[7]),
            )
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
            Container(
              width: width / 3,
              decoration: decoration(imageKeys[0]),
            ),
            Container(
              width: width / 3,
              decoration: decoration(imageKeys[1]),
            ),
            Container(
              width: width / 3,
              decoration: decoration(imageKeys[2]),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Container(
              width: width / 3,
              decoration: decoration(imageKeys[3]),
            ),
            Container(
              width: width / 3,
              decoration: decoration(imageKeys[4]),
            ),
            Container(
              width: width / 3,
              decoration: decoration(imageKeys[5]),
            )
          ],
        ),
        Row(
          children: <Widget>[
            Container(
              width: width / 3,
              decoration: decoration(imageKeys[6]),
            ),
            Container(
              width: width / 3,
              decoration: decoration(imageKeys[7]),
            ),
            Container(
              width: width / 3,
              decoration: decoration(imageKeys[8]),
            )
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
            Container(
              width: width / 3,
              decoration: decoration(imageKeys[0]),
            ),
            Container(
              width: width / 3,
              decoration: decoration(imageKeys[1]),
            ),
            Container(
              width: width / 3,
              decoration: decoration(imageKeys[2]),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Container(
              width: width / 3,
              decoration: decoration(imageKeys[3]),
            ),
            Container(
              width: width / 3,
              decoration: decoration(imageKeys[4]),
            ),
            Container(
              width: width / 3,
              decoration: decoration(imageKeys[5]),
            )
          ],
        ),
        Row(
          children: <Widget>[
            Container(
              width: width / 4,
              decoration: decoration(imageKeys[6]),
            ),
            Container(
              width: width / 4,
              decoration: decoration(imageKeys[7]),
            ),
            Container(
              width: width / 4,
              decoration: decoration(imageKeys[8]),
            ),
            Container(
              width: width / 4,
              decoration: decoration(imageKeys[9]),
            )
          ],
        ),
      ],
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
