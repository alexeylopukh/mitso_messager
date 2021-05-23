import 'dart:io';

class DocumentLocalStore {
  final String dir;

  DocumentLocalStore(this.dir);

  Future<File> getFile(String filename) async {
    File file = File('$dir/$filename');
    if (await file.exists()) {
      return file;
    } else
      return null;
  }
}
