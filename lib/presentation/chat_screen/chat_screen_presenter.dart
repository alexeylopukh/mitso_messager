import 'dart:async';
import 'dart:io';

import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:messager/interactor/socket_interactor.dart';
import 'package:messager/interactor/typing_detector.dart';
import 'package:messager/network/rpc/get_room_member_rpc.dart';
import 'package:messager/network/rpc/upload_image.dart';
import 'package:messager/objects/chat_message.dart';
import 'package:messager/objects/chat_message_image.dart';
import 'package:messager/objects/chat_room.dart';
import 'package:messager/objects/upload_image.dart';
import 'package:messager/presentation/chat_screen/chat_screen_view_model.dart';
import 'package:messager/presentation/chat_screen/widgets/attach_file_popup.dart';
import 'package:messager/presentation/di/user_scope_data.dart';
import 'package:messager/presentation/helper/socket_helper.dart';
import 'package:path/path.dart';

class ChatScreenPresenter {
  final UserScopeData userScope;
  final int roomId;
  StreamController<ChatScreenViewModel> _viewModelStream = StreamController();
  ChatScreenViewModel viewModel;

  DateTime lastShowToast;

  StreamController<List<UploadImage>> uploadImagesStream = StreamController();
  List<UploadImage> uploadImages = [];

  StreamController<List<UploadImage>> uploadFilesStream = StreamController();
  List<UploadImage> uploadFiles = [];

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
      this.unsendedMessages = unsendedMessages.isNotEmpty ? unsendedMessages.reversed.toList() : [];
      if (screenIsBuilded) updateView();
    });
    TypingDetector(
        textEditingController: messageController,
        onStopTyping: () => sendTypingStatus(false),
        onStartTyping: () => sendTypingStatus(true));
    loadChatMembers();
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

  void loadChatMembers() async {
    viewModel.users = await GetRoomMembersRpc(userScope).getMembers(roomId);
    updateView();
  }

  ChatRoom _getCurrentRoom() {
    List<ChatRoom> chatRooms = socketInteractor.chatRoomStream.valueWrapper.value;
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

  void uploadPickedFiles(PickedFiles pickedFiles) {
    pickedFiles.files.forEach((photo) {
      uploadImage(photo, pickedFiles.type);
    });
  }

  uploadImage(File file, PickFileType pickFileType) {
    if (uploadImages.length >= 10) {
      if (lastShowToast == null || DateTime.now().difference(lastShowToast).inSeconds > 1) {
        lastShowToast = DateTime.now();
        Fluttertoast.showToast(msg: 'Максимальное кол-во файлов 10 шт.');
        return;
      }
      return;
    }
    UploadImage currentUploadImage = UploadImage(
      file,
      UploadImageState.Uploading,
      pickFileType,
    );
    currentUploadImage.onRetryClick = () {
      currentUploadImage.state = UploadImageState.Uploading;
      uploadImagesStream.add(uploadImages);
      Future<String> uploadWork = UploadImageRpc(userScope)
          .upload(file, isMessage: 1, pickFileType: pickFileType)
          .catchError((e) {
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
    Future<String> uploadWork = UploadImageRpc(userScope)
        .upload(file, isMessage: 1, pickFileType: pickFileType)
        .catchError((e) {
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

  onSendButtonClick() async {
    String message = messageController.text.trim();
    if (message.isEmpty && uploadImages.isEmpty) return;
    if (haveUnuploadedPhoto()) return;
    messageController.clear();
    List<String> photos = [];
    if (uploadImages.isNotEmpty) {
      uploadImages.forEach((UploadImage i) {
        if (i.fileType == PickFileType.Image) photos.add(i.key);
      });
      uploadImages.removeWhere((element) {
        return element.fileType == PickFileType.Image;
      });
      uploadImagesStream.add(uploadImages);
    }
    List<ChatMessageDocument> documents = [];
    if (uploadImages.isNotEmpty) {
      uploadImages.forEach((UploadImage i) {
        documents.add(ChatMessageDocument(key: i.key, fileName: basename(i.file.path)));
      });
      uploadImages.removeWhere((element) {
        return element.fileType == PickFileType.Document;
      });
      uploadImagesStream.add(uploadImages);
    }

    socketInteractor.sendMessage(roomId, message, photos, documents);
  }

  bool haveUnuploadedPhoto() {
    bool have = false;
    uploadImages.forEach((UploadImage i) {
      if (i.state != UploadImageState.Uploaded) have = true;
    });
    return have;
  }

  void updateView() async {
    if (viewModel.chatRoom == null) return;
    List<ChatMessage> messages = [];
    messages.addAll(unsendedMessages);
    messages.addAll(viewModel.chatRoom.messages);
    viewModel.messages = messages;
    _viewModelStream.add(viewModel);
  }

  void onLeaveExitClick() async {
    socketInteractor.socket.sendData("on_leave_room", {
      "room_id": viewModel.chatRoom.id,
      "is_direct": viewModel.chatRoom.isDirect,
    });
  }

  void dispose() {
    _viewModelStream?.close();
    uploadImagesStream?.close();
    uploadFilesStream?.close();
  }
}
