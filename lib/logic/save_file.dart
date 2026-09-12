import 'dart:io';
class SaveFile {
 static savefile({required String fileName, required List<int> fileData}) {
    late final home = Platform.environment['HOME'];
    late var file = File('$home/Downloads/$fileName');
    file.writeAsBytes(fileData);
  }
}