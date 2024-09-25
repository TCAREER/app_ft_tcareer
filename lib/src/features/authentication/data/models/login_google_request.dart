class LoginGoogleRequest {
  LoginGoogleRequest({
      String? accessToken,}){
    _accessToken = accessToken;
}

  LoginGoogleRequest.fromJson(dynamic json) {
    _accessToken = json['access_token'];
  }
  String? _accessToken;
LoginGoogleRequest copyWith({  String? accessToken,
}) => LoginGoogleRequest(  accessToken: accessToken ?? _accessToken,
);
  String? get accessToken => _accessToken;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['access_token'] = _accessToken;
    return map;
  }

}