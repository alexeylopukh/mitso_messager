import 'dart:async';
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

class ChatScreenPresenter {
  final UserScopeData userScope;
  final int roomId;
  StreamController<ChatScreenViewModel> _viewModelStream = StreamController();
  ChatScreenViewModel viewModel;

  DateTime lastShowToast;

  StreamController<List<UploadImage>> uploadImagesStream = StreamController();
  List<UploadImage> uploadImages = [];

  bool screenIsBuilded = false;

  ChatScreenPresenter({@required this.userScope, @required this.roomId}) {
    viewModel = ChatScreenViewModel(chatRoom: _getCurrentRoom());
    viewModel.messages = viewModel.chatRoom.messages;
    init();
  }

  init() async {
    socketInteractor.chatRoomStream.listen((_) {
      viewModel.chatRoom = _getCurrentRoom();
      if (screenIsBuilded) updateView();
    });
    socketInteractor.unsendedMessages.listen((List<ChatMessage> messages) {
      List<ChatMessage> unsendedMessages = [];
      if (messages.isNotEmpty)
        messages.forEach((ChatMessage message) {
          if (message.roomId == roomId) unsendedMessages.add(message);
        });
      unsendedMessages = unsendedMessages.isNotEmpty ? unsendedMessages.reversed.toList() : [];
      if (screenIsBuilded) updateView();
    });
    TypingDetector(
        textEditingController: messageController,
        onStopTyping: () => sendTypingStatus(false),
        onStartTyping: () => sendTypingStatus(true));
  }

  TextEditingController messageController = TextEditingController();

  SocketHelper get _socket => userScope.socketHelper;

  SocketInteractor get socketInteractor => _socket.socketInteractor;

  Stream<ChatScreenViewModel> get viewModelSteam => _viewModelStream.stream;
  List<ChatMessage> unsendedMessages = [];

  loadChatHistory() async {
    var messages =
        await socketInteractor.getChatHistory(roomId, viewModel.chatRoom.messages.last.id);
    if (messages != null) {
      viewModel.chatRoom.messages.addAll(messages);
      updateView();
    }
  }

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
    if (uploadImages.length >= 10) {
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
      uploadImagesStream.add(uploadImages);
      Future<String> uploadWork =
          UploadImageRpc(userScope).upload(file, isMessage: 1).catchError((e) {
        currentUploadImage.state = UploadImageState.Error;
        uploadImagesStream.add(uploadImages);
      }).then((String value) {
        if (value != null) {
          currentUploadImage.key = value;
          currentUploadImage.state = UploadImageState.Uploaded;
          uploadImagesStream.add(uploadImages);
          return value;
        }
        return null;
      });
      currentUploadImage.operation = CancelableOperation<String>.fromFuture(uploadWork);
      uploadImagesStream.add(uploadImages);
    };
    Future<String> uploadWork =
        UploadImageRpc(userScope).upload(file, isMessage: 1).catchError((e) {
      currentUploadImage.state = UploadImageState.Error;
      uploadImagesStream.add(uploadImages);
    }).then((String value) {
      if (value != null) {
        currentUploadImage.key = value;
        currentUploadImage.state = UploadImageState.Uploaded;
        uploadImagesStream.add(uploadImages);
        return value;
      }
      return null;
    });

    currentUploadImage.operation = CancelableOperation<String>.fromFuture(uploadWork);
    currentUploadImage.onDeleteClick = () {
      uploadImages.remove(currentUploadImage);
      uploadImagesStream.add(uploadImages);
    };
    uploadImages.add(currentUploadImage);
    uploadImagesStream.add(uploadImages);
  }

  sendTypingStatus(bool isTyping) {
    socketInteractor.sendTypingStatus(isTyping, roomId);
  }

  onSendButtonClick() {
    String message = messageController.text.trim();
    if (message.isEmpty && uploadImages.isEmpty) return;
    if (haveUnuploadedPhoto()) return;
    messageController.clear();
    List<String> photos = [];
    if (uploadImages.isNotEmpty) {
      uploadImages.forEach((UploadImage i) {
        photos.add(i.key);
      });
      uploadImages.clear();
      uploadImagesStream.add(uploadImages);
    }

    socketInteractor.sendMessage(roomId, message, photos);
  }

  bool haveUnuploadedPhoto() {
    bool have = false;
    uploadImages.forEach((UploadImage i) {
      if (i.state != UploadImageState.Uploaded) have = true;
    });
    return have;
  }

  void updateView() async {
    List<ChatMessage> messages = [];
    messages.addAll(unsendedMessages);
    messages.addAll(viewModel.chatRoom.messages);
    viewModel.messages = messages;
    _viewModelStream.add(viewModel);
  }

  void dispose() {
    _viewModelStream?.close();
    uploadImagesStream?.close();
  }
}
