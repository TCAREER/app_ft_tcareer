class UploadData {
  UploadData({
      String? fileUrl,}){
    _fileUrl = fileUrl;
}

  UploadData.fromJson(dynamic json) {
    _fileUrl = json['file_url'];
  }
  String? _fileUrl;
UploadData copyWith({  String? fileUrl,
}) => UploadData(  fileUrl: fileUrl ?? _fileUrl,
);
  String? get fileUrl => _fileUrl;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['file_url'] = _fileUrl;
    return map;
  }

}