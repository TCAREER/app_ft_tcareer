class MessageModel {
  MessageModel({
    num? id,
    num? conversationId,
    num? senderId,
    String? content,
    String? type,
    String? createdAt,
    String? updatedAt,
    dynamic deletedAt,
  }) {
    _id = id;
    _conversationId = conversationId;
    _senderId = senderId;
    _content = content;
    _type = type;
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
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _deletedAt = json['deleted_at'];
  }
  num? _id;
  num? _conversationId;
  num? _senderId;
  String? _content;
  String? _type;
  String? _createdAt;
  String? _updatedAt;
  dynamic _deletedAt;
  MessageModel copyWith({
    num? id,
    num? conversationId,
    num? senderId,
    String? content,
    String? type,
    String? createdAt,
    String? updatedAt,
    dynamic deletedAt,
  }) =>
      MessageModel(
        id: id ?? _id,
        conversationId: conversationId ?? _conversationId,
        senderId: senderId ?? _senderId,
        content: content ?? _content,
        type: type ?? _type,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
        deletedAt: deletedAt ?? _deletedAt,
      );
  num? get id => _id;
  num? get conversationId => _conversationId;
  num? get senderId => _senderId;
  String? get content => _content;
  String? get type => _type;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  dynamic get deletedAt => _deletedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['conversation_id'] = _conversationId;
    map['sender_id'] = _senderId;
    map['content'] = _content;
    map['type'] = _type;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    map['deleted_at'] = _deletedAt;
    return map;
  }
}
