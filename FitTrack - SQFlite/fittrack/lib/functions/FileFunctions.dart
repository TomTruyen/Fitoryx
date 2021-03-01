import 'dart:io';

import 'package:ext_storage/ext_storage.dart';

Future<String> getDevicePath() async {
  final directory = await ExtStorage.getExternalStoragePublicDirectory(
      ExtStorage.DIRECTORY_DOWNLOADS);

  return directory;
}

Future<File> getFile(String path, String fileName) async {
  return File('$path/$fileName');
}

Future<File> writeToFile(File file, String data) async {
  try {
    await file.create(recursive: true);
    File writtenFile = await file.writeAsString(data);

    return writtenFile;
  } catch (e) {
    print("Write To File Error: $e");
    return null;
  }
}

Future<dynamic> readFromFile(File file) async {
  try {
    String data = await file.readAsString();

    return data;
  } catch (e) {
    print("Read From File Error: $e");
    return null;
  }
}