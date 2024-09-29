class LoginRequest {
  LoginRequest({
    String? phone,
    String? password,
    String? deviceId,
  }) {
    _phone = phone;
    _password = password;
    _deviceId = deviceId;
  }

  LoginRequest.fromJson(dynamic json) {
    _phone = json['phone'];
    _password = json['password'];
    _deviceId = json['device_id'];
  }
  String? _phone;
  String? _password;
  String? _deviceId;
  LoginRequest copyWith({
    String? phone,
    String? password,
    String? deviceId,
  }) =>
      LoginRequest(
        phone: phone ?? _phone,
        password: password ?? _password,
        deviceId: deviceId ?? _deviceId,
      );
  String? get phone => _phone;
  String? get password => _password;
  String? get deviceId => _deviceId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['phone'] = _phone;
    map['password'] = _password;
    map['device_id'] = _deviceId;
    return map;
  }
}
