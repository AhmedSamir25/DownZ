import 'package:downz/logic/file_download_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'file_download_state.dart';
class FileDownloadCubit extends Cubit<FileDownloadState> {
  FileDownloadCubit() : super(const FileDownloadState());
  final FileDownloadService _fileDownloadService = FileDownloadService();

  Future<void> downloadFile({required String url})async{
    emit(FileDownloadLoadingState());
    try {
      await _fileDownloadService.downloadFile(url: url);
      emit(FileDownloadSuccessState());
    } catch (e) {
      emit(FileDownloadErrorState(message: e.toString()));
    }
  }
}