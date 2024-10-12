// file_type_checker.dart
extension FileTypeChecker on String {
  bool get isVideo =>
      this.contains('https://res.cloudinary.com') ||
      this.contains("https://drive.google.com/uc?export=download&id=");

  bool get isVideoNetWork => this.contains("https");
}

extension ListFileTypeChecker on List<String> {
  bool get hasVideos => any((url) => url.isVideo);
}
