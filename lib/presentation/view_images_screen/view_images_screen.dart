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
  List<PhotoViewScaleStateController> controllers;
  bool _isCloseButtonVisible = true;

  @override
  void initState() {
    _pageController = PreloadPageController(initialPage: widget.initalPage);
    currentPage = widget.initalPage;
    controllers = [];
    widget.imageKeys.forEach((_) {
      controllers.add(PhotoViewScaleStateController());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _isCloseButtonVisible = !_isCloseButtonVisible;
        if (mounted) setState(() {});
      },
      child: Material(
        color: Colors.black,
        child: Stack(
          children: [
            PreloadPageView.builder(
              preloadPagesCount: widget.imageKeys.length,
              controller: _pageController,
              physics: BouncingScrollPhysics(),
              itemCount: widget.imageKeys.length,
              itemBuilder: (BuildContext context, int i) {
                return PhotoView.customChild(
                  scaleStateController: controllers[i],
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
                  childSize:
                      Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height),
                  minScale: PhotoViewComputedScale.contained,
                  maxScale: PhotoViewComputedScale.covered * 3,
                );
              },
              onPageChanged: (int page) {
                controllers[currentPage].scaleState = PhotoViewScaleState.originalSize;
                currentPage = page;
              },
            ),
            AnimatedOpacity(
              opacity: _isCloseButtonVisible ? 1 : 0,
              duration: Duration(milliseconds: 200),
              child: IgnorePointer(
                ignoring: !_isCloseButtonVisible,
                child: Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).padding.top + 10,
                        right: MediaQuery.of(context).padding.right + 10),
                    child: ClipOval(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            height: 50,
                            width: 50,
                            color: Colors.black.withOpacity(0.5),
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.close,
                              color: Colors.white.withOpacity(0.7),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
