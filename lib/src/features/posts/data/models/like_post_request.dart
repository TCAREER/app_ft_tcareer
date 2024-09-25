class LikePostRequest {
  LikePostRequest({
    String? postId,
  }) {
    _postId = postId;
  }

  LikePostRequest.fromJson(dynamic json) {
    _postId = json['post_id'];
  }
  String? _postId;

  LikePostRequest copyWith({
    String? postId,
  }) =>
      LikePostRequest(
        postId: postId ?? _postId,
      );
  String? get postId => _postId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['post_id'] = _postId;

    return map;
  }
}
