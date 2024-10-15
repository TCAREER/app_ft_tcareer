class AllConversation {
  AllConversation({
      List<Data>? data, 
      Response? response,}){
    _data = data;
    _response = response;
}

  AllConversation.fromJson(dynamic json) {
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Data.fromJson(v));
      });
    }
    _response = json['response'] != null ? Response.fromJson(json['response']) : null;
  }
  List<Data>? _data;
  Response? _response;
AllConversation copyWith({  List<Data>? data,
  Response? response,
}) => AllConversation(  data: data ?? _data,
  response: response ?? _response,
);
  List<Data>? get data => _data;
  Response? get response => _response;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    if (_response != null) {
      map['response'] = _response?.toJson();
    }
    return map;
  }

}

class Response {
  Response({
      String? status, 
      num? code, 
      num? count,}){
    _status = status;
    _code = code;
    _count = count;
}

  Response.fromJson(dynamic json) {
    _status = json['status'];
    _code = json['code'];
    _count = json['count'];
  }
  String? _status;
  num? _code;
  num? _count;
Response copyWith({  String? status,
  num? code,
  num? count,
}) => Response(  status: status ?? _status,
  code: code ?? _code,
  count: count ?? _count,
);
  String? get status => _status;
  num? get code => _code;
  num? get count => _count;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['code'] = _code;
    map['count'] = _count;
    return map;
  }

}

class Data {
  Data({
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

  Data.fromJson(dynamic json) {
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
Data copyWith({  num? id,
  num? userId,
  String? leftAt,
  String? userAvatar,
  String? userFullName,
  String? latestMessage,
  String? updatedAt,
}) => Data(  id: id ?? _id,
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