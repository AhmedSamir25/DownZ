String extractFileName({required String url}) {
  final uri = Uri.parse(url);
  if (uri.pathSegments.isEmpty || uri.pathSegments.last.isEmpty) {
    return 'download';
  }
  return uri.pathSegments.last;
}
