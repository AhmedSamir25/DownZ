import 'package:dio/dio.dart';
import 'package:downz/logic/save_file.dart';
class FileDownloadService {
  final Dio _dio = Dio();
  Future<void> downloadFile({required String url}) async {
    try {
      final response = await _dio.get(
        url,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );
      SaveFile.savefile(fileName: url);
    } catch (e) {
      throw Exception('Failed to download file: $e');
    }
  }
}