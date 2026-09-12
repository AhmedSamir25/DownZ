import 'package:downz/logic/cubit/file_download_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  static const _ink = Color(0xFF16221F);
  static const _paper = Color(0xFFFFFAF2);
  static const _coral = Color(0xFFFF5E4D);
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
        }
        if (state is FileDownloadSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              behavior: SnackBarBehavior.floating,
              backgroundColor: _ink,
              content: Text('Your download has started.'),
            ),
          );
        }
      },
      builder: (context, state) {
        final progress = state is FileDownloadProgressState
            ? state.progress.clamp(0.0, 1.0).toDouble()
            : 0.0;
        final isDownloading =
            state is FileDownloadLoadingState ||
            state is FileDownloadProgressState;
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
                          Container(
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
                                  controller: _urlController,
                                  focusNode: _urlFocusNode,
                                  enabled: !isDownloading,
                                  keyboardType: TextInputType.url,
                                  textInputAction: TextInputAction.done,
                                  onSubmitted: (_) => _download(),
                                  autocorrect: false,
                                  enableSuggestions: false,
                                  style: const TextStyle(
                                    color: _ink,
                                    fontSize: 16,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'https://example.com/file.zip',
                                    hintStyle: const TextStyle(
                                      color: Color(0xFF89948F),
                                    ),
                                    prefixIcon: const Icon(
                                      Icons.link_rounded,
                                      color: _coral,
                                    ),
                                    suffixIcon: _hasText
                                        ? IconButton(
                                            icon: const Icon(
                                              Icons.close_rounded,
                                            ),
                                            color: const Color(0xFF66726D),
                                            tooltip: 'Clear link',
                                            onPressed: _urlController.clear,
                                          )
                                        : null,
                                    filled: true,
                                    fillColor: const Color(0xFFFFFCF7),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 18,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(14),
                                      borderSide: const BorderSide(
                                        color: Color(0xFFD6DDD8),
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(14),
                                      borderSide: const BorderSide(
                                        color: Color(0xFFD6DDD8),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(14),
                                      borderSide: const BorderSide(
                                        color: _coral,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                ),
                                if (isDownloading) ...[
                                  const SizedBox(height: 18),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                        state is FileDownloadProgressState
                                            ? '${(progress * 100).round()}%'
                                            : 'Preparing…',
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
                                      value: state is FileDownloadProgressState
                                          ? progress
                                          : null,
                                      minHeight: 8,
                                      backgroundColor: const Color(0xFFF4E4DA),
                                      valueColor: const AlwaysStoppedAnimation(
                                        _coral,
                                      ),
                                    ),
                                  ),
                                  if (state is FileDownloadProgressState) ...[
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '${_formatBytes(state.receivedBytes)} of ${_formatBytes(state.totalBytes)}',
                                          style: const TextStyle(
                                            color: Color(0xFF66726D),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          '${_formatBytes(state.bytesPerSecond)}/s',
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
                                const SizedBox(height: 18),
                                SizedBox(
                                  width: double.infinity,
                                  height: 56,
                                  child: FilledButton(
                                    onPressed: isDownloading || !_hasText
                                        ? null
                                        : _download,
                                    style: FilledButton.styleFrom(
                                      backgroundColor: _coral,
                                      disabledBackgroundColor: const Color(
                                        0xFFFFB5AC,
                                      ),
                                      foregroundColor: Colors.white,
                                      disabledForegroundColor: Colors.white70,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                    ),
                                    child: AnimatedSwitcher(
                                      duration: const Duration(
                                        milliseconds: 180,
                                      ),
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
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Start download',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w800,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                SizedBox(width: 9),
                                                Icon(
                                                  Icons.south_rounded,
                                                  size: 20,
                                                ),
                                              ],
                                            ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 28),
                          const Row(
                            children: [
                              Icon(
                                Icons.verified_user_outlined,
                                color: _ink,
                                size: 18,
                              ),
                              SizedBox(width: 9),
                              Expanded(
                                child: Text(
                                  'Your link is used only to start this download.',
                                  style: TextStyle(
                                    color: Color(0xFF50615B),
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
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
