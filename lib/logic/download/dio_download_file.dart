import 'package:dio/dio.dart';
import 'package:downz/logic/download/download_file.dart';

import 'extract_file_name.dart';
import 'file_store.dart';

final class DioDownloadFile implements DownloadFile {
  DioDownloadFile({Dio? dio, FileStore? fileStore})
    : _dio = dio ?? Dio(),
      _fileStore = fileStore ?? FileStore();

  final Dio _dio;
  final FileStore _fileStore;

  @override
  Future<void> call({
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
      await _fileStore.save(
        fileName: extractFileName(url: url),
        fileData: response.data,
      );
    } catch (e) {
      throw Exception('Failed to download file: $e');
    }
  }
}
