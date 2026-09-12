part of 'file_download_cubit.dart';
class FileDownloadState {
  const FileDownloadState();
}

final class FileDownloadLoadingState extends FileDownloadState{}

final class FileDownloadSuccessState extends FileDownloadState{}

final class FileDownloadErrorState extends FileDownloadState{
  final String message;
  const FileDownloadErrorState({required this.message});
}