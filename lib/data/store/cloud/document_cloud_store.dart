import 'dart:io';

import 'package:http/http.dart' as http;

class DocumentCloudStore {
  final String dir;

  DocumentCloudStore(this.dir);

  Future<File> downloadDocument(String url, String filename) async {
    http.Client client = new http.Client();
    var req = await client.get(Uri.parse(url));
    var bytes = req.bodyBytes;
    File file = new File('$dir/$filename');
    await file.writeAsBytes(bytes);
    return file;
  }
}
