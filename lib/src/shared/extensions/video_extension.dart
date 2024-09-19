// file_type_checker.dart
extension FileTypeChecker on String {
  bool get isVideo => this.contains(
      'https://firebasestorage.googleapis.com/v0/b/tcareer-4fa7d.appspot.com/o/Posts%2FVideos%');
}

extension ListFileTypeChecker on List<String> {
  bool get hasVideos => any((url) => url.isVideo);
}
