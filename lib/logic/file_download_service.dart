import 'package:dio/dio.dart';
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
      // Handle the downloaded file here
    } catch (e) {
      throw Exception('Failed to download file: $e');
    }
  }
}