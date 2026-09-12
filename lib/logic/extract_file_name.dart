String extractFileName({required String url}){
  final uri = Uri.parse(url);
  final ext = uri.pathSegments.last.split('.').last.toLowerCase();
  return ext;
}