part of 'file_download_cubit.dart';

class FileDownloadState {
  const FileDownloadState();
}

final class FileDownloadLoadingState extends FileDownloadState {}

final class FileDownloadProgressState extends FileDownloadState {
  final double progress;
  final int receivedBytes;
  final int totalBytes;
  final double bytesPerSecond;

  const FileDownloadProgressState({
    required this.progress,
    required this.receivedBytes,
    required this.totalBytes,
    required this.bytesPerSecond,
  });
}

final class FileDownloadSuccessState extends FileDownloadState {
  const FileDownloadSuccessState();
}

final class FileDownloadErrorState extends FileDownloadState {
  final String message;
  const FileDownloadErrorState({required this.message});
}
