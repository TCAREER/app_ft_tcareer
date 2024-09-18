// file_type_checker.dart
extension FileTypeChecker on String {
  bool get isVideo => this.contains('uc?export=download&id=');
}

extension ListFileTypeChecker on List<String> {
  bool get hasVideos => any((url) => url.isVideo);
}
