import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:messager/constants.dart';
import 'package:messager/network/rpc/upload_image.dart';
import 'package:messager/presentation/components/custom_button.dart';
import 'package:messager/presentation/components/custom_elevation.dart';
import 'package:messager/presentation/components/general_scaffold.dart';
import 'package:messager/presentation/components/popups.dart';
import 'package:messager/presentation/di/custom_theme.dart';
import 'package:messager/presentation/di/user_scope_data.dart';

class CreateRoomScreen extends StatefulWidget {
  @override
  _CreateRoomScreenState createState() => _CreateRoomScreenState();
}

class _CreateRoomScreenState extends State<CreateRoomScreen> {
  final TextEditingController nameController = TextEditingController();
  bool isNetworkOperation = false;
  bool isAvatarUploaded = false;
  File uploadedImage;
  String uploadedAvatarKey;

  @override
  Widget build(BuildContext context) {
    return GeneralScaffold(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: TextFormField(
                controller: nameController,
                textCapitalization: TextCapitalization.sentences,
                autocorrect: true,
                enableInteractiveSelection: true,
                cursorColor: CustomTheme.of(context).primaryColor,
                decoration: InputDecoration(
                  hintText: 'Название',
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  contentPadding:
                      EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 5),
                ),
              ),
            ),
            avatarView(),
            Spacer(),
            Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom + 10,
                  left: 20,
                  right: 20),
              child: CustomButton(
                child: isNetworkOperation
                    ? CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 2.0,
                      )
                    : Text(
                        'Создать',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: CustomTheme.of(context).boldFontFamily),
                      ),
                height: 50,
                width: double.infinity,
                onTap: () {
                  if (!isNetworkOperation) {
                    createRoom();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  avatarView() {
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
                    image: uploadedImage != null
                        ? DecorationImage(
                            fit: BoxFit.cover, image: FileImage(uploadedImage))
                        : null,
                  ),
                  child: Container(),
                ),
                if (isAvatarUploaded)
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
              'Выбрать фото',
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
              uploadAvatar(croppedFile);
            },
          )
        ],
      ),
    );
  }

  uploadAvatar(File file) async {
    uploadedAvatarKey = null;
    uploadedImage = file;
    isAvatarUploaded = true;
    update();
    String avatarKey = await UploadImageRpc(UserScopeWidget.of(context))
        .upload(file, roomId: '0')
        .catchError((e) {
      if (e is UploadImageRpcException)
        Popups.showModalDialog(context, PopupState.OK, description: e.message);
      else
        Popups.showModalDialog(context, PopupState.OK,
            description: UNKNOWN_ERROR_MESSAGE);
      uploadedImage = null;
    });
    isAvatarUploaded = false;
    update();
    if (avatarKey != null) {
      uploadedAvatarKey = avatarKey;
    }
  }

  createRoom() async {
    if (nameController.value.text.trim().isEmpty) return;
    isNetworkOperation = true;
    update();
    var socket = UserScopeWidget.of(context).socketHelper;

    socket.sendData('on_create_room', {
      'room_name': nameController.value.text.trim(),
      'thumb_image_key': uploadedAvatarKey
    });
    socket.createRoomCompleter = Completer();
    bool result = await socket.createRoomCompleter.future
        .timeout(Duration(seconds: 3))
        .catchError((e) {
      //ignore
    });
    isNetworkOperation = false;
    update();
    if (result == true) {
      socket.sendData('on_rooms', {});
      Navigator.of(context).pop();
    } else {
      Fluttertoast.showToast(
          msg: 'Не удалось создать чат',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          fontSize: 16.0);
    }
  }

  update() {
    if (mounted) setState(() {});
  }
}
