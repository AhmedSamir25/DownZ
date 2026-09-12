import 'package:downz/logic/file_download_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../progress_bar.dart';

part 'file_download_state.dart';

class FileDownloadCubit extends Cubit<FileDownloadState> {
  FileDownloadCubit() : super(const FileDownloadState());
  final FileDownloadService _fileDownloadService = FileDownloadService();
  int _lastPercent = -1;
  Future<void> downloadFile({required String url}) async {
    emit(FileDownloadLoadingState());
    _lastPercent = -1;
    try {
      await _fileDownloadService.downloadFile(
        url: url,
        onProgress: (received, total) {
          if (total <= 0) return;
          final percent = (received / total * 100).floor();
          if (percent == _lastPercent) return;
          _lastPercent = percent;
          emit(
            FileDownloadProgressState(
              progress: progressBarValue(received.toDouble(), total.toDouble()),
              receivedBytes: received,
              totalBytes: total,
            ),
          );
        },
      );
      emit(FileDownloadSuccessState());
    } catch (e) {
      emit(FileDownloadErrorState(message: e.toString()));
    }
  }
}
