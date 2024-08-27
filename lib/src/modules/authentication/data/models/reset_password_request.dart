class ResetPasswordRequest {
  ResetPasswordRequest({
      String? email, 
      String? password, 
      String? key,}){
    _email = email;
    _password = password;
    _key = key;
}

  ResetPasswordRequest.fromJson(dynamic json) {
    _email = json['email'];
    _password = json['password'];
    _key = json['key'];
  }
  String? _email;
  String? _password;
  String? _key;
ResetPasswordRequest copyWith({  String? email,
  String? password,
  String? key,
}) => ResetPasswordRequest(  email: email ?? _email,
  password: password ?? _password,
  key: key ?? _key,
);
  String? get email => _email;
  String? get password => _password;
  String? get key => _key;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['email'] = _email;
    map['password'] = _password;
    map['key'] = _key;
    return map;
  }

}