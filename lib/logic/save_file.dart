import 'dart:io';
class SaveFile {
 static savefile({required String fileName}){
    late final home = Platform.environment['HOME'];
    late var file = File('$home/Downloads/$fileName');
  }
}