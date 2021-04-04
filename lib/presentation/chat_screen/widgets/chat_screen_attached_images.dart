import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:messager/objects/chat_message_image.dart';
import 'package:messager/presentation/view_images_screen/view_images_screen.dart';
import 'package:shimmer/shimmer.dart';

import '../../../constants.dart';

class ChatScreenAttachedImages extends StatefulWidget {
  final List<ChatMessageImage> imageKeys;

  const ChatScreenAttachedImages({Key key, @required this.imageKeys}) : super(key: key);

  @override
  _ChatScreenAttachedImagesState createState() => _ChatScreenAttachedImagesState();
}

class _ChatScreenAttachedImagesState extends State<ChatScreenAttachedImages> {
  List<ChatMessageImage> get imageKeys => widget.imageKeys;
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
    return createContainer(width, 0);
  }

  Widget layout2() {
    return Row(
      children: <Widget>[
        createContainer(width / 2, 0),
        createContainer(width / 2, 1),
      ],
    );
  }

  Widget layout3() {
    return Column(
      children: <Widget>[
        createContainer(width, 0),
        Row(
          children: <Widget>[
            createContainer(width / 2, 1),
            createContainer(width / 2, 2),
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
            createContainer(width / 2, 0),
            createContainer(width / 2, 1),
          ],
        ),
        Row(
          children: <Widget>[
            createContainer(width / 2, 2),
            createContainer(width / 2, 3),
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
            createContainer(width / 2, 0),
            createContainer(width / 2, 1),
          ],
        ),
        Row(
          children: <Widget>[
            createContainer(width / 3, 2),
            createContainer(width / 3, 3),
            createContainer(width / 3, 4)
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
            createContainer(width / 3, 0),
            createContainer(width / 3, 1),
            createContainer(width / 3, 2),
          ],
        ),
        Row(
          children: <Widget>[
            createContainer(width / 3, 3),
            createContainer(width / 3, 4),
            createContainer(width / 3, 5),
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
            createContainer(width / 2, 0),
            createContainer(width / 2, 1),
          ],
        ),
        Row(
          children: <Widget>[
            createContainer(width / 2, 2),
            createContainer(width / 2, 3),
          ],
        ),
        Row(
          children: <Widget>[
            createContainer(width / 3, 4),
            createContainer(width / 3, 5),
            createContainer(width / 3, 6),
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
            createContainer(width / 2, 0),
            createContainer(width / 2, 1),
          ],
        ),
        Row(
          children: <Widget>[
            createContainer(width / 3, 2),
            createContainer(width / 3, 3),
            createContainer(width / 3, 4),
          ],
        ),
        Row(
          children: <Widget>[
            createContainer(width / 3, 5),
            createContainer(width / 3, 6),
            createContainer(width / 3, 7),
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
            createContainer(width / 3, 0),
            createContainer(width / 3, 1),
            createContainer(width / 3, 2),
          ],
        ),
        Row(
          children: <Widget>[
            createContainer(width / 3, 3),
            createContainer(width / 3, 4),
            createContainer(width / 3, 5),
          ],
        ),
        Row(
          children: <Widget>[
            createContainer(width / 3, 6),
            createContainer(width / 3, 7),
            createContainer(width / 3, 8),
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
              0,
            ),
            createContainer(
              width / 3,
              1,
            ),
            createContainer(
              width / 3,
              2,
            ),
          ],
        ),
        Row(
          children: <Widget>[
            createContainer(
              width / 3,
              3,
            ),
            createContainer(
              width / 3,
              4,
            ),
            createContainer(
              width / 3,
              5,
            ),
          ],
        ),
        Row(
          children: <Widget>[
            createContainer(
              width / 4,
              6,
            ),
            createContainer(
              width / 4,
              7,
            ),
            createContainer(
              width / 4,
              8,
            ),
            createContainer(
              width / 4,
              9,
            )
          ],
        ),
      ],
    );
  }

  Widget createContainer(double width, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (c) {
          return ViewImagesScreen(
            imageKeys: imageKeys,
            initalPage: index,
          );
        }));
      },
      child: Padding(
        padding: EdgeInsets.all(0.5),
        child: SizedBox(
          height: width,
          width: width,
          child: Hero(
            tag: imageKeys[index],
            child: CachedNetworkImage(
              imageUrl: API_URL + '/' + imageKeys[index].key,
              fit: BoxFit.cover,
              repeat: ImageRepeat.repeat,
              placeholder: (c, s) {
                return SizedBox(
                  height: width,
                  width: width,
                  child: Shimmer.fromColors(
                    child: Container(
                      height: width,
                      width: width,
                      color: Color(0xffE9E9E9),
                    ),
                    baseColor: Color(0xffE9E9E9),
                    highlightColor: Colors.grey[350],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration decoration(String key) {
    return BoxDecoration(
        image: key == null
            ? null
            : DecorationImage(
                fit: BoxFit.cover,
                image: CachedNetworkImageProvider(
                  API_URL + '/' + key,
                ),
              ));
  }
}
