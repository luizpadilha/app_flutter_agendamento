import 'dart:convert';
import 'dart:io';
import 'package:uuid/uuid.dart';


import 'package:path_provider/path_provider.dart';

bool isNullOrEmpty(dynamic value) {
  if (value == null) {
    return true;
  }
  if (value is String && value.isEmpty) {
    return true;
  }
  if ((value is List || value is Map) && value.isEmpty) {
    return true;
  }
  return false;
}

Future<String?> converterFileToBase64(File? file) async {
  String? fileBase64;
  if (file != null) {
    List<int> fileBytes = await file.readAsBytes();
    fileBase64 = base64Encode(fileBytes);
  }
  return fileBase64;
}

Future<File?> converterBase64ToFile(String? fileBase64) async {
  File? file;
  if (fileBase64 != null) {
    List<int> fileBytes = base64Decode(fileBase64);
    final Directory tempDir = await getTemporaryDirectory();
    var uuid = const Uuid();
    String filePath = '${tempDir.path}/temp_file_${uuid.v4()}';
    file = File(filePath);
    await file.writeAsBytes(fileBytes);
  }
  return file;
}


