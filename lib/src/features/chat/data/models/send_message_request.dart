class SendMessageRequest {
  SendMessageRequest({
    num? conversationId,
    String? content,
    List<dynamic>? mediaUrl,
  }) {
    _conversationId = conversationId;
    _content = content;
    _mediaUrl = mediaUrl;
  }

  SendMessageRequest.fromJson(dynamic json) {
    _conversationId = json['conversation_id'];
    _content = json['content'];
    if (json['media_url'] != null) {
      _mediaUrl = [];
      json['media_url'].forEach((v) {
        _mediaUrl?.add(v);
      });
    }
  }
  num? _conversationId;
  String? _content;
  List<dynamic>? _mediaUrl;
  SendMessageRequest copyWith({
    num? conversationId,
    String? content,
    List<dynamic>? mediaUrl,
  }) =>
      SendMessageRequest(
        conversationId: conversationId ?? _conversationId,
        content: content ?? _content,
        mediaUrl: mediaUrl ?? _mediaUrl,
      );
  num? get conversationId => _conversationId;
  String? get content => _content;
  List<dynamic>? get mediaUrl => _mediaUrl;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['conversation_id'] = _conversationId;
    map['content'] = _content;
    if (_mediaUrl != null) {
      map['media_url'] = _mediaUrl?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
