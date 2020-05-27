import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:messager/presentation/components/custom_button.dart';
import 'package:messager/presentation/components/custom_elevation.dart';
import 'package:messager/presentation/di/custom_theme.dart';
import 'package:messager/presentation/di/user_scope_data.dart';

enum MoreScreenAvatarViewState { None, Uploading }

class MoreScreenAvatarView extends StatefulWidget {
  @override
  _MoreScreenAvatarViewState createState() => _MoreScreenAvatarViewState();
}

class _MoreScreenAvatarViewState extends State<MoreScreenAvatarView> {
  File uploadedImage;
  MoreScreenAvatarViewState state = MoreScreenAvatarViewState.None;

  @override
  Widget build(BuildContext context) {
    var profile = UserScopeWidget.of(context).myProfile;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          CustomElevation(
            height: 100,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: CustomTheme.of(context).primaryColor,
                    image: profile.avatarUrl == null
                        ? uploadedImage == null
                            ? null
                            : DecorationImage(
                                fit: BoxFit.cover,
                                image: FileImage(uploadedImage))
                        : DecorationImage(
                            fit: BoxFit.cover,
                            image:
                                CachedNetworkImageProvider(profile.avatarUrl),
                          ),
                  ),
                  child: profile.avatarUrl == null && uploadedImage == null
                      ? Center(
                          child: Text(
                            profile.name.split('').first.toUpperCase(),
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily:
                                    CustomTheme.of(context).boldFontFamily,
                                fontSize: 50),
                          ),
                        )
                      : null,
                ),
                if (state == MoreScreenAvatarViewState.Uploading)
                  Container(
                    height: 96,
                    width: 96,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 4.0,
                    ),
                  )
              ],
            ),
          ),
          CustomButton(
            height: 50,
            width: 100,
            child: Text(
              'Загрузить другое',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
            onTap: () async {
              File file = await FilePicker.getFile(type: FileType.image);
              if (file == null) return;
              File croppedFile = await ImageCropper.cropImage(
                  sourcePath: file.path,
                  aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
                  maxWidth: 512,
                  maxHeight: 512,
                  androidUiSettings: AndroidUiSettings(
                      toolbarTitle: 'Cropper',
                      toolbarColor: CustomTheme.of(context).primaryColor,
                      toolbarWidgetColor: Colors.white,
                      initAspectRatio: CropAspectRatioPreset.square,
                      lockAspectRatio: false),
                  iosUiSettings: IOSUiSettings(
                    minimumAspectRatio: 1.0,
                  ));
              if (croppedFile == null) return;
              uploadedImage = croppedFile;
              state = MoreScreenAvatarViewState.Uploading;
              update();
            },
          )
        ],
      ),
    );
  }

  update() {
    if (mounted) setState(() {});
  }
}
