import 'dart:io';

class FileStore {
  Future<void> save({
    required String fileName,
    required List<int> fileData,
  }) async {
    late final home = Platform.environment['HOME'];
    var file = File('$home/Downloads/$fileName');
    var counter = 1;

    while (await file.exists()) {
      file = File('$home/Downloads/$fileName($counter)');
      counter++;
    }

    await file.writeAsBytes(fileData);
  }
}
