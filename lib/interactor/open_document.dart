import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:messager/objects/chat_message_image.dart';
import 'package:messager/presentation/components/popups.dart';
import 'package:messager/presentation/di/user_scope_data.dart';
import 'package:open_file/open_file.dart';

class OpenDocument {
  final BuildContext context;

  OpenDocument(this.context);

  Future open(
    ChatMessageDocument document,
  ) async {
    File file;
    try {
      file = await Popups.showProgressPopup(
          context, UserScopeWidget.of(context).documentsRepository.getFile(document));
    } catch (e) {}
    if (file == null) {
      showError();
      return;
    }
    OpenFile.open(file.path);
  }

  void showError() {
    Popups.showModalDialog(context, PopupState.OK, description: 'Ошибка при загрузке файла');
  }
}
