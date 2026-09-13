import 'package:downz/logic/cubits/file_download_cubit.dart';
import 'package:flutter/material.dart';

class DownloadProgress extends StatelessWidget {
  const DownloadProgress({required this.state, super.key});

  static const _ink = Color(0xFF16221F);
  static const _coral = Color(0xFFFF5E4D);

  final FileDownloadState state;

  @override
  Widget build(BuildContext context) {
    final progressState = state is FileDownloadProgressState
        ? state as FileDownloadProgressState
        : null;
    final progress = progressState?.progress.clamp(0.0, 1.0).toDouble();

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'DOWNLOADING',
              style: TextStyle(
                color: _ink,
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.1,
              ),
            ),
            Text(
              progress == null ? 'Preparing…' : '${(progress * 100).round()}%',
              style: const TextStyle(
                color: _coral,
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(99),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: const Color(0xFFF4E4DA),
            valueColor: const AlwaysStoppedAnimation(_coral),
          ),
        ),
        if (progressState != null) ...[
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_formatBytes(progressState.receivedBytes)} of '
                '${_formatBytes(progressState.totalBytes)}',
                style: const TextStyle(
                  color: Color(0xFF66726D),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${_formatBytes(progressState.bytesPerSecond)}/s',
                style: const TextStyle(
                  color: _ink,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  String _formatBytes(num bytes) {
    const units = ['B', 'KB', 'MB', 'GB', 'TB'];
    var value = bytes.toDouble();
    var unitIndex = 0;

    while (value >= 1024 && unitIndex < units.length - 1) {
      value /= 1024;
      unitIndex++;
    }

    final precision = value >= 100 || unitIndex == 0 ? 0 : 1;
    return '${value.toStringAsFixed(precision)} ${units[unitIndex]}';
  }
}
