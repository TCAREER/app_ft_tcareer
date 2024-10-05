class LoginRequest {
  LoginRequest({
      String? phone, 
      String? password, 
      String? deviceId, 
      String? deviceToken,}){
    _phone = phone;
    _password = password;
    _deviceId = deviceId;
    _deviceToken = deviceToken;
}

  LoginRequest.fromJson(dynamic json) {
    _phone = json['phone'];
    _password = json['password'];
    _deviceId = json['device_id'];
    _deviceToken = json['device_token'];
  }
  String? _phone;
  String? _password;
  String? _deviceId;
  String? _deviceToken;
LoginRequest copyWith({  String? phone,
  String? password,
  String? deviceId,
  String? deviceToken,
}) => LoginRequest(  phone: phone ?? _phone,
  password: password ?? _password,
  deviceId: deviceId ?? _deviceId,
  deviceToken: deviceToken ?? _deviceToken,
);
  String? get phone => _phone;
  String? get password => _password;
  String? get deviceId => _deviceId;
  String? get deviceToken => _deviceToken;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['phone'] = _phone;
    map['password'] = _password;
    map['device_id'] = _deviceId;
    map['device_token'] = _deviceToken;
    return map;
  }

}