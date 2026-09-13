import 'package:downz/logic/cubits/file_download_cubit.dart';
import 'package:downz/view/download/widgets/download_progress.dart';
import 'package:flutter/material.dart';

class DownloadForm extends StatelessWidget {
  const DownloadForm({
    required this.controller,
    required this.focusNode,
    required this.hasText,
    required this.state,
    required this.onDownload,
    super.key,
  });

  static const _ink = Color(0xFF16221F);
  static const _coral = Color(0xFFFF5E4D);

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool hasText;
  final FileDownloadState state;
  final VoidCallback onDownload;

  @override
  Widget build(BuildContext context) {
    final isDownloading =
        state is FileDownloadLoadingState || state is FileDownloadProgressState;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: _ink, width: 1.5),
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x2416221F),
            offset: Offset(7, 7),
            blurRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'FILE URL',
            style: TextStyle(
              color: _ink,
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: controller,
            focusNode: focusNode,
            enabled: !isDownloading,
            keyboardType: TextInputType.url,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => onDownload(),
            autocorrect: false,
            enableSuggestions: false,
            style: const TextStyle(color: _ink, fontSize: 16),
            decoration: InputDecoration(
              hintText: 'https://example.com/file.zip',
              hintStyle: const TextStyle(color: Color(0xFF89948F)),
              prefixIcon: const Icon(Icons.link_rounded, color: _coral),
              suffixIcon: hasText
                  ? IconButton(
                      icon: const Icon(Icons.close_rounded),
                      color: const Color(0xFF66726D),
                      tooltip: 'Clear link',
                      onPressed: controller.clear,
                    )
                  : null,
              filled: true,
              fillColor: const Color(0xFFFFFCF7),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 18,
              ),
              border: _inputBorder(),
              enabledBorder: _inputBorder(),
              focusedBorder: _inputBorder(color: _coral, width: 2),
            ),
          ),
          if (isDownloading) ...[
            const SizedBox(height: 18),
            DownloadProgress(state: state),
          ],
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: FilledButton(
              onPressed: isDownloading || !hasText ? null : onDownload,
              style: FilledButton.styleFrom(
                backgroundColor: _coral,
                disabledBackgroundColor: const Color(0xFFFFB5AC),
                foregroundColor: Colors.white,
                disabledForegroundColor: Colors.white70,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                child: isDownloading
                    ? const SizedBox(
                        key: ValueKey('loader'),
                        height: 21,
                        width: 21,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : const Row(
                        key: ValueKey('label'),
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Start download',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(width: 9),
                          Icon(Icons.south_rounded, size: 20),
                        ],
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  OutlineInputBorder _inputBorder({
    Color color = const Color(0xFFD6DDD8),
    double width = 1,
  }) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}
