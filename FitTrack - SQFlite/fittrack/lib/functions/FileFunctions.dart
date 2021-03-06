import 'dart:io';

import 'package:ext_storage/ext_storage.dart';
import 'package:package_info/package_info.dart';

import 'package:fittrack/shared/Globals.dart' as globals;

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

Future autoExportData() async {
  try {
    String devicePath = await getDevicePath();

    PackageInfo _packageInfo = await PackageInfo.fromPlatform();

    File file = await getFile(
      devicePath,
      'FitTrack-Auto-Export-v${_packageInfo.version}-b${_packageInfo.buildNumber}.db',
    );

    dynamic result = await globals.sqlDatabase.exportDatabase();

    if (result != null) {
      await writeToFile(file, result.toString());
    }
  } catch (e) {
    print("Auto Export Data Error: $e");
  }
}
