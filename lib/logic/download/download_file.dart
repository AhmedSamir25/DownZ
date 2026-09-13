typedef DownloadProgressCallback =
    void Function(int received, int total, double bytesPerSecond);

abstract interface class DownloadFile {
  Future<void> call({
    required String url,
    DownloadProgressCallback? onProgress,
  });
}
