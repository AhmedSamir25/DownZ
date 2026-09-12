import 'package:dio/dio.dart';
import 'package:downz/logic/extract_file_name.dart';
import 'package:downz/logic/progress_bar.dart';
import 'package:downz/logic/save_file.dart';
class FileDownloadService {
  final Dio _dio = Dio();

  Future<void> downloadFile({required String url, void Function(int received, int total)? onProgress,}) async {
    try {
      final response = await _dio.get(
        url,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            print('Downloading: ${(received / total * 100).toStringAsFixed(0)}%');
            // progressBarValue(received, total);
            onProgress?.call(received, total);
          }
        },
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: true,
          validateStatus: (status) {
            return status! < 500;
          },
        ),
      );
      SaveFile.savefile(fileName: extractFileName(url: url), fileData: response.data);
    } catch (e) {
      throw Exception('Failed to download file: $e');
    }
  }
}