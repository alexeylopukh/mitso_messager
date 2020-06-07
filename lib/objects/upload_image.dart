import 'dart:io';

import 'package:async/async.dart';

enum UploadImageState { Uploading, Error, Uploaded }

class UploadImage {
  File file;
  String key;
  CancelableOperation<String> operation;
  UploadImageState state;
  Function onRetryClick;
  Function onDeleteClick;

  UploadImage(this.file, this.state,
      {this.operation, this.onRetryClick, this.onDeleteClick, this.key});
}
