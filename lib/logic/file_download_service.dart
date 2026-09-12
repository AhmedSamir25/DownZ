import 'package:dio/dio.dart';
import 'package:downz/logic/extract_file_name.dart';
import 'package:downz/logic/save_file.dart';

class FileDownloadService {
  final Dio _dio = Dio();

  Future<void> downloadFile({
    required String url,
    void Function(int received, int total, double bytesPerSecond)? onProgress,
  }) async {
    final stopwatch = Stopwatch()..start();
    try {
      final response = await _dio.get(
        url,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            final elapsedSeconds = stopwatch.elapsedMicroseconds / 1000000;
            final bytesPerSecond = elapsedSeconds > 0
                ? received / elapsedSeconds
                : 0.0;
            onProgress?.call(received, total, bytesPerSecond);
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
      stopwatch.stop();
      SaveFile.savefile(
        fileName: extractFileName(url: url),
        fileData: response.data,
      );
    } catch (e) {
      throw Exception('Failed to download file: $e');
    }
  }
}
