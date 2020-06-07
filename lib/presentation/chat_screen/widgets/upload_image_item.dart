import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:messager/objects/upload_image.dart';
import 'package:messager/presentation/di/custom_theme.dart';

class UploadImageItem extends StatefulWidget {
  final UploadImage uploadImage;

  const UploadImageItem({Key key, @required this.uploadImage}) : super(key: key);

  @override
  _UploadImageItemState createState() => _UploadImageItemState();
}

class _UploadImageItemState extends State<UploadImageItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: 60,
      child: Align(
        alignment: Alignment.center,
        child: Stack(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(5),
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: FileImage(widget.uploadImage.file), fit: BoxFit.cover)),
                ),
              ),
            ),
            if (widget.uploadImage.state == UploadImageState.Uploading)
              Padding(
                padding: EdgeInsets.all(5),
                child: Container(
                  color: Colors.black.withOpacity(0.3),
                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      Container(
                        height: 50,
                        width: 50,
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(CustomTheme.of(context).primaryColor),
                          strokeWidth: 2.0,
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: ClipOval(
                          child: Material(
                            color: Colors.white.withOpacity(0.5),
                            child: InkWell(
                              onTap: widget.uploadImage.onDeleteClick,
                              child: Icon(
                                Icons.close,
                                size: 33,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else if (widget.uploadImage.state == UploadImageState.Error)
              Padding(
                padding: EdgeInsets.all(5),
                child: Container(
                  color: Colors.black.withOpacity(0.3),
                  child: Align(
                    alignment: Alignment.center,
                    child: ClipOval(
                      child: Container(
                        height: 40,
                        width: 40,
                        alignment: Alignment.center,
                        child: Material(
                          color: Colors.white.withOpacity(0.5),
                          child: InkWell(
                            onTap: widget.uploadImage.onRetryClick,
                            child: Icon(
                              Icons.refresh,
                              size: 40,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            else
              Align(
                alignment: Alignment.topRight,
                child: ClipOval(
                  child: Material(
                    color: Colors.white.withOpacity(0.6),
                    child: InkWell(
                      onTap: widget.uploadImage.onDeleteClick,
                      child: Icon(
                        Icons.close,
                        size: 20,
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
