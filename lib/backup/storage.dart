import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share/share.dart';
import 'package:file_picker/file_picker.dart';
import '../models/book_model.dart';

class Storage {
  Future<String> get _localPath async {
    // 1
    final directory = await getApplicationDocumentsDirectory();
    var path = directory.path;

    return path;
  }

  Future<File> get _localFile async {
    // 2
    final path = await _localPath;
    return File('$path/books backup.json');
  }

  Future<File> writeBooks(List<Book> books) async {
    // 3
    if (!await Permission.storage.request().isGranted) {
      // 4
      return Future.value(null);
    }

    final file = await _localFile;
    if (!await file.exists()) {
      // 5
      await file.create(recursive: true);
    }

    String encodedPeople =
        jsonEncode(books.map((e) => e.toMap()).toList()); // 6
    return file.writeAsString(encodedPeople); // 7
  }

  Future<List<Book>> readBooks([bool local = true, File? selectedFile]) async {
    // 1
    try {
      // start of 2
      File file;
      if (local) {
        file = await _localFile;
      } else {
        file = selectedFile!;
      }
      // end of 2

      final jsonContents = await file.readAsString(); // 3
      List<dynamic> jsonResponse = json.decode(jsonContents); // 4
      return jsonResponse.map((i) => Book.fromMap(i)).toList(); // 5
    } catch (e) {
      // If encountering an empty array
      return [];
    }
  }

  void share(List<Book> books) async {
    writeBooks(books);
    File file = await _localFile; // 1
    Share.shareFiles([file.path], text: 'books backup'); // 2
  }

  Future<List<Book>> readFromFilePicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(); // 1

    if (result == null) {
      // 2
      return Future.value(readBooks());
    }

    File file = File(result.files.single.path!); // 3
    var books = readBooks(false, file); // 4
    writeBooks(await books); // 5
    return books;
  }
}
