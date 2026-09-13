import 'package:downz/logic/download/calculate_progress.dart';
import 'package:downz/logic/download/download_file.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'file_download_state.dart';

class FileDownloadCubit extends Cubit<FileDownloadState> {
  FileDownloadCubit(this._downloadFile) : super(const FileDownloadState());

  final DownloadFile _downloadFile;
  int _lastPercent = -1;

  Future<void> downloadFile({required String url}) async {
    emit(FileDownloadLoadingState());
    _lastPercent = -1;
    try {
      await _downloadFile(
        url: url,
        onProgress: (received, total, bytesPerSecond) {
          if (total <= 0) return;
          final percent = (received / total * 100).floor();
          if (percent == _lastPercent) return;
          _lastPercent = percent;
          emit(
            FileDownloadProgressState(
              progress: calculateProgress(received, total),
              receivedBytes: received,
              totalBytes: total,
              bytesPerSecond: bytesPerSecond,
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
