import 'dart:io';

import 'package:async/async.dart';
import 'package:messager/presentation/chat_screen/widgets/attach_file_popup.dart';

enum UploadImageState { Uploading, Error, Uploaded }

class UploadImage {
  File file;
  String key;
  CancelableOperation<String> operation;
  UploadImageState state;
  Function onRetryClick;
  Function onDeleteClick;
  PickFileType fileType;

  UploadImage(this.file, this.state, this.fileType,
      {this.operation, this.onRetryClick, this.onDeleteClick, this.key});
}
