import 'dart:io';

import 'package:messager/data/store/cloud/document_cloud_store.dart';
import 'package:messager/data/store/local/document_local_store.dart';
import 'package:messager/objects/chat_message_image.dart';
import 'package:path_provider/path_provider.dart';

import '../../constants.dart';

class DocumentsRepository {
  DocumentsRepository() {
    init();
  }

  DocumentCloudStore _cloudStore;
  DocumentLocalStore _localStore;

  init() async {
    String dir = (await getTemporaryDirectory()).path;
    _localStore = DocumentLocalStore(dir);
    _cloudStore = DocumentCloudStore(dir);
  }

  Future<File> getFile(ChatMessageDocument document) async {
    File file = await _localStore.getFile(document.fileName);
    if (file == null) {
      file = await _cloudStore
          .downloadDocument(API_URL + "/" + document.key, document.fileName)
          .onError((error, stackTrace) {
        return null;
      });
    }
    return file;
  }
}
