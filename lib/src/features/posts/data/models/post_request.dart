class PostRequest {
  PostRequest({
      String? personal, 
      String? profileUserId,}){
    _personal = personal;
    _profileUserId = profileUserId;
}

  PostRequest.fromJson(dynamic json) {
    _personal = json['personal'];
    _profileUserId = json['profile_user_id'];
  }
  String? _personal;
  String? _profileUserId;
PostRequest copyWith({  String? personal,
  String? profileUserId,
}) => PostRequest(  personal: personal ?? _personal,
  profileUserId: profileUserId ?? _profileUserId,
);
  String? get personal => _personal;
  String? get profileUserId => _profileUserId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['personal'] = _personal;
    map['profile_user_id'] = _profileUserId;
    return map;
  }

}