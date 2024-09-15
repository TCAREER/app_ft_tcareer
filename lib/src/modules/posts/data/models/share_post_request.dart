class SharePostRequest {
  SharePostRequest({
      num? postId, 
      String? privacy,}){
    _postId = postId;
    _privacy = privacy;
}

  SharePostRequest.fromJson(dynamic json) {
    _postId = json['post_id'];
    _privacy = json['privacy'];
  }
  num? _postId;
  String? _privacy;
SharePostRequest copyWith({  num? postId,
  String? privacy,
}) => SharePostRequest(  postId: postId ?? _postId,
  privacy: privacy ?? _privacy,
);
  num? get postId => _postId;
  String? get privacy => _privacy;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['post_id'] = _postId;
    map['privacy'] = _privacy;
    return map;
  }

}