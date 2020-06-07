import 'dart:io';

import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:messager/interactor/socket_interactor.dart';
import 'package:messager/interactor/typing_detector.dart';
import 'package:messager/network/rpc/upload_image.dart';
import 'package:messager/objects/chat_message.dart';
import 'package:messager/objects/chat_room.dart';
import 'package:messager/objects/upload_image.dart';
import 'package:messager/presentation/chat_screen/chat_screen_view_model.dart';
import 'package:messager/presentation/chat_screen/widgets/attach_file_popup.dart';
import 'package:messager/presentation/di/user_scope_data.dart';
import 'package:messager/presentation/helper/socket_helper.dart';
import 'package:rxdart/rxdart.dart';

class ChatScreenPresenter {
  final UserScopeData userScope;
  final int roomId;
  BehaviorSubject<ChatScreenViewModel> _viewModelStream;

  DateTime lastShowToast;

  BehaviorSubject<List<UploadImage>> uploadImages = BehaviorSubject.seeded([]);

  ChatScreenPresenter({@required this.userScope, @required this.roomId}) {
    socketInteractor.chatRoomStream.listen((_) {
      var vm = _viewModelStream.value;
      vm.chatRoom = _getCurrentRoom();
      _viewModelStream.add(vm);
    });
    socketInteractor.unsendedMessages.listen((List<ChatMessage> messages) {
      var vm = _viewModelStream.value;
      List<ChatMessage> unsendedMessages = [];
      if (messages.isNotEmpty)
        messages.forEach((ChatMessage message) {
          if (message.roomId == roomId) unsendedMessages.add(message);
        });
      vm.unsendedMessages = unsendedMessages.isNotEmpty ? unsendedMessages.reversed.toList() : [];
      _viewModelStream.add(vm);
    });
    _viewModelStream = BehaviorSubject.seeded(ChatScreenViewModel(chatRoom: _getCurrentRoom()));
    TypingDetector(
        textEditingController: messageController,
        onStopTyping: () => sendTypingStatus(false),
        onStartTyping: () => sendTypingStatus(true));
  }

  TextEditingController messageController = TextEditingController();

  SocketHelper get _socket => userScope.socketHelper;

  SocketInteractor get socketInteractor => _socket.socketInteractor;

  ValueStream<ChatScreenViewModel> get viewModelSteam => _viewModelStream.stream;

  ChatRoom _getCurrentRoom() {
    List<ChatRoom> chatRooms = socketInteractor.chatRoomStream.value;
    var roomsIterator = chatRooms.iterator;
    ChatRoom foundedRoom;
    while (roomsIterator.moveNext()) {
      ChatRoom currentRoom = roomsIterator.current;
      if (currentRoom.id == roomId) {
        foundedRoom = currentRoom;
        break;
      }
    }
    return foundedRoom;
  }

  uploadFiles(PickedFiles pickedFiles) {
    switch (pickedFiles.type) {
      case PickFileType.Document:
        break;
      case PickFileType.Image:
        pickedFiles.files.forEach((photo) {
          uploadImage(photo);
        });
        break;
    }
  }

  uploadImage(File file) {
    if (uploadImages.value.length >= 10) {
      if (lastShowToast == null || DateTime.now().difference(lastShowToast).inSeconds > 1) {
        lastShowToast = DateTime.now();
        Fluttertoast.showToast(msg: 'Максимальное кол-во фото 10 шт.');
        return;
      }
      return;
    }
    UploadImage currentUploadImage = UploadImage(
      file,
      UploadImageState.Uploading,
    );
    currentUploadImage.onRetryClick = () {
      currentUploadImage.state = UploadImageState.Uploading;
      uploadImages.add(uploadImages.value);
      Future<String> uploadWork =
          UploadImageRpc(userScope).upload(file, isMessage: 1).catchError((e) {
        currentUploadImage.state = UploadImageState.Error;
        uploadImages.add(uploadImages.value);
      }).then((String value) {
        if (value != null) {
          currentUploadImage.key = value;
          currentUploadImage.state = UploadImageState.Uploaded;
          uploadImages.add(uploadImages.value);
          return value;
        }
        return null;
      });
      currentUploadImage.operation = CancelableOperation<String>.fromFuture(uploadWork);
      uploadImages.add(uploadImages.value);
    };
    Future<String> uploadWork =
        UploadImageRpc(userScope).upload(file, isMessage: 1).catchError((e) {
      currentUploadImage.state = UploadImageState.Error;
      uploadImages.add(uploadImages.value);
    }).then((String value) {
      if (value != null) {
        currentUploadImage.key = value;
        currentUploadImage.state = UploadImageState.Uploaded;
        uploadImages.add(uploadImages.value);
        return value;
      }
      return null;
    });

    currentUploadImage.operation = CancelableOperation<String>.fromFuture(uploadWork);
    currentUploadImage.onDeleteClick = () {
      uploadImages.add(uploadImages.value..remove(currentUploadImage));
    };
    uploadImages.add(uploadImages.value..add(currentUploadImage));
  }

  sendTypingStatus(bool isTyping) {
    socketInteractor.sendTypingStatus(isTyping, roomId);
  }

  onSendButtonClick() {
    String message = messageController.text.trim();
    if (message.isEmpty && uploadImages.value.isEmpty) return;
    if (haveUnuploadedPhoto()) return;
    messageController.clear();
    List<String> photos = [];
    if (uploadImages.value.isNotEmpty)
      uploadImages.value.forEach((UploadImage i) {
        photos.add(i.key);
      });
    socketInteractor.sendMessage(roomId, message, photos);
  }

  bool haveUnuploadedPhoto() {
    bool have = false;
    uploadImages.value.forEach((UploadImage i) {
      if (i.state != UploadImageState.Uploaded) have = true;
    });
    return have;
  }

  dispose() {
    _viewModelStream?.close();
    uploadImages?.close();
  }
}
