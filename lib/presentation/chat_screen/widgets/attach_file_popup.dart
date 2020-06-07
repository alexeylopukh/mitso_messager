import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:messager/presentation/di/custom_theme.dart';

enum PickFileType { Document, Image }

class PickedFiles {
  List<File> files;
  PickFileType type;

  PickedFiles(this.files, this.type);
}

Future<PickedFiles> showAttachFilePopup(BuildContext context) async {
  PickedFiles pickedFiles;
  await showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
            backgroundColor: CustomTheme.of(context).backgroundColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16.0))),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _buildPopupItem('Фото из галереи', context, () async {
                  List<File> files = await FilePicker.getMultiFile(
                    type: FileType.image,
                  );
                  if (files != null) pickedFiles = PickedFiles(files, PickFileType.Image);
                  Navigator.pop(context);
                }),
                _buildPopupItem('Сделать фото', context, () async {
                  var picketFile = await ImagePicker().getImage(source: ImageSource.camera);
                  var file = File(picketFile.path);
                  if (file != null) pickedFiles = PickedFiles([file], PickFileType.Image);
                  Navigator.pop(context);
                }),
                _buildPopupItem('Файлы', context, () async {
                  List<File> files = await FilePicker.getMultiFile(type: FileType.any);
                  if (files != null) pickedFiles = PickedFiles(files, PickFileType.Document);
                  Navigator.pop(context);
                })
              ],
            ),
          ));
  print(pickedFiles);
  return pickedFiles;
}

Widget _buildPopupItem(
  String text,
  BuildContext context,
  Function onClick,
) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(16),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onClick,
        child: Container(
          width: double.infinity,
          height: 50,
          margin: EdgeInsets.symmetric(horizontal: 10),
          alignment: Alignment.centerLeft,
          child: Text(
            text,
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    ),
  );
}
