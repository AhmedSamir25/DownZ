import 'package:downz/logic/cubits/file_download_cubit.dart';
import 'package:downz/view/download/widgets/download_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DownloadView extends StatefulWidget {
  const DownloadView({super.key});

  @override
  State<DownloadView> createState() => _DownloadViewState();
}

class _DownloadViewState extends State<DownloadView> {
  static const _ink = Color(0xFF16221F);
  static const _paper = Color(0xFFFFFAF2);
  static const _mint = Color(0xFFD8F4DF);

  final _urlController = TextEditingController();
  final _urlFocusNode = FocusNode();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _urlController.addListener(_handleUrlChange);
  }

  @override
  void dispose() {
    _urlController
      ..removeListener(_handleUrlChange)
      ..dispose();
    _urlFocusNode.dispose();
    super.dispose();
  }

  void _handleUrlChange() {
    final hasText = _urlController.text.trim().isNotEmpty;
    if (_hasText != hasText) setState(() => _hasText = hasText);
  }

  void _download() {
    final url = _urlController.text.trim();
    if (url.isEmpty) {
      _urlFocusNode.requestFocus();
      return;
    }
    FocusScope.of(context).unfocus();
    context.read<FileDownloadCubit>().downloadFile(url: url);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FileDownloadCubit, FileDownloadState>(
      listener: (context, state) {
        if (state is FileDownloadErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              backgroundColor: _ink,
              content: Text('Download failed: ${state.message}'),
            ),
          );
        } else if (state is FileDownloadSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              behavior: SnackBarBehavior.floating,
              backgroundColor: _ink,
              content: Text('Your download is complete.'),
            ),
          );
        }
      },
      builder: (context, state) {
        final size = MediaQuery.sizeOf(context);
        final horizontalPadding = size.width < 420 ? 24.0 : 32.0;

        return Scaffold(
          backgroundColor: _paper,
          body: SafeArea(
            child: Stack(
              children: [
                const Positioned(
                  top: -88,
                  right: -76,
                  child: _CircleDecoration(size: 248, color: _mint),
                ),
                const Positioned(
                  bottom: -54,
                  left: -44,
                  child: _CircleDecoration(size: 176, color: Color(0xFFFFD8A8)),
                ),
                Center(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(
                      horizontalPadding,
                      28,
                      horizontalPadding,
                      28,
                    ),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 520),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 7,
                            ),
                            decoration: BoxDecoration(
                              color: _ink,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: const Text(
                              'DOWNZ  /  FILE GRABBER',
                              style: TextStyle(
                                color: _paper,
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.15,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'Bring the file\nto you.',
                            style: TextStyle(
                              color: _ink,
                              fontSize: size.width < 390 ? 48 : 56,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -2.7,
                              height: .94,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Paste a direct file link and we’ll take care of the rest.',
                            style: TextStyle(
                              color: Color(0xFF50615B),
                              fontSize: 16,
                              height: 1.45,
                            ),
                          ),
                          const SizedBox(height: 42),
                          DownloadForm(
                            controller: _urlController,
                            focusNode: _urlFocusNode,
                            hasText: _hasText,
                            state: state,
                            onDownload: _download,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _CircleDecoration extends StatelessWidget {
  const _CircleDecoration({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    );
  }
}
