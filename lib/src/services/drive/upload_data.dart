class UploadData {
  UploadData({
      String? id,}){
    _id = id;
}

  UploadData.fromJson(dynamic json) {
    _id = json['id'];
  }
  String? _id;
UploadData copyWith({  String? id,
}) => UploadData(  id: id ?? _id,
);
  String? get id => _id;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    return map;
  }

}