import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:preload_page_view/preload_page_view.dart';

import '../../constants.dart';

class ViewImagesScreen extends StatefulWidget {
  final List<String> imageKeys;
  final int initalPage;

  const ViewImagesScreen({Key key, @required this.imageKeys, @required this.initalPage})
      : super(key: key);

  @override
  _ViewImagesScreenState createState() => _ViewImagesScreenState();
}

class _ViewImagesScreenState extends State<ViewImagesScreen> {
  PreloadPageController _pageController;
  int currentPage;

  @override
  void initState() {
    _pageController = PreloadPageController(initialPage: widget.initalPage);
    currentPage = widget.initalPage;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      child: PreloadPageView.builder(
        preloadPagesCount: widget.imageKeys.length,
        controller: _pageController,
        itemCount: widget.imageKeys.length,
        itemBuilder: (BuildContext context, int i) {
          return PhotoView.customChild(
            child: i == currentPage
                ? Hero(
                    tag: widget.imageKeys[i],
                    child: CachedNetworkImage(
                      imageUrl: API_URL + '/' + widget.imageKeys[i],
                    ),
                  )
                : CachedNetworkImage(
                    imageUrl: API_URL + '/' + widget.imageKeys[i],
                  ),
            childSize: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height),
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 3,
          );
        },
        onPageChanged: (int page) {
          currentPage = page;
        },
      ),
    );
  }
}
