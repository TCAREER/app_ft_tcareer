class MessageModel {
  MessageModel({
    num? id,
    num? conversationId,
    num? senderId,
    String? content,
    String? type,
    List<String>? mediaUrl,
    String? createdAt,
    String? updatedAt,
    String? deletedAt,
  }) {
    _id = id;
    _conversationId = conversationId;
    _senderId = senderId;
    _content = content;
    _type = type;
    _mediaUrl = mediaUrl;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _deletedAt = deletedAt;
  }

  MessageModel.fromJson(dynamic json) {
    _id = json['id'];
    _conversationId = json['conversation_id'];
    _senderId = json['sender_id'];
    _content = json['content'];
    _type = json['type'];
    _mediaUrl =
        json['media_url'] != null ? json['media_url'].cast<String>() : [];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _deletedAt = json['deleted_at'];
  }
  num? _id;
  num? _conversationId;
  num? _senderId;
  String? _content;
  String? _type;
  List<String>? _mediaUrl;
  String? _createdAt;
  String? _updatedAt;
  String? _deletedAt;
  MessageModel copyWith({
    num? id,
    num? conversationId,
    num? senderId,
    String? content,
    String? type,
    List<String>? mediaUrl,
    String? createdAt,
    String? updatedAt,
    String? deletedAt,
  }) =>
      MessageModel(
        id: id ?? _id,
        conversationId: conversationId ?? _conversationId,
        senderId: senderId ?? _senderId,
        content: content ?? _content,
        type: type ?? _type,
        mediaUrl: mediaUrl ?? _mediaUrl,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
        deletedAt: deletedAt ?? _deletedAt,
      );
  num? get id => _id;
  num? get conversationId => _conversationId;
  num? get senderId => _senderId;
  String? get content => _content;
  String? get type => _type;
  List<String>? get mediaUrl => _mediaUrl;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  String? get deletedAt => _deletedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['conversation_id'] = _conversationId;
    map['sender_id'] = _senderId;
    map['content'] = _content;
    map['type'] = _type;
    map['media_url'] = _mediaUrl;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    map['deleted_at'] = _deletedAt;
    return map;
  }
}