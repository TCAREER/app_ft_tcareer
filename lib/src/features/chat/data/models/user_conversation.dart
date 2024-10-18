class UserConversation {
  UserConversation({
      num? id, 
      num? userId, 
      String? leftAt, 
      String? userAvatar, 
      String? userFullName, 
      String? latestMessage, 
      String? updatedAt,}){
    _id = id;
    _userId = userId;
    _leftAt = leftAt;
    _userAvatar = userAvatar;
    _userFullName = userFullName;
    _latestMessage = latestMessage;
    _updatedAt = updatedAt;
}

  UserConversation.fromJson(dynamic json) {
    _id = json['id'];
    _userId = json['user_id'];
    _leftAt = json['left_at'];
    _userAvatar = json['user_avatar'];
    _userFullName = json['user_full_name'];
    _latestMessage = json['latest_message'];
    _updatedAt = json['updated_at'];
  }
  num? _id;
  num? _userId;
  String? _leftAt;
  String? _userAvatar;
  String? _userFullName;
  String? _latestMessage;
  String? _updatedAt;
UserConversation copyWith({  num? id,
  num? userId,
  String? leftAt,
  String? userAvatar,
  String? userFullName,
  String? latestMessage,
  String? updatedAt,
}) => UserConversation(  id: id ?? _id,
  userId: userId ?? _userId,
  leftAt: leftAt ?? _leftAt,
  userAvatar: userAvatar ?? _userAvatar,
  userFullName: userFullName ?? _userFullName,
  latestMessage: latestMessage ?? _latestMessage,
  updatedAt: updatedAt ?? _updatedAt,
);
  num? get id => _id;
  num? get userId => _userId;
  String? get leftAt => _leftAt;
  String? get userAvatar => _userAvatar;
  String? get userFullName => _userFullName;
  String? get latestMessage => _latestMessage;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['user_id'] = _userId;
    map['left_at'] = _leftAt;
    map['user_avatar'] = _userAvatar;
    map['user_full_name'] = _userFullName;
    map['latest_message'] = _latestMessage;
    map['updated_at'] = _updatedAt;
    return map;
  }

}