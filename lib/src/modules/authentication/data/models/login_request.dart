import 'package:json_annotation/json_annotation.dart';

part 'login_request.g.dart'; // File này sẽ được tạo tự động sau khi chạy build_runner

@JsonSerializable()
class LoginRequest {
  final String? email;
  final String? phone;
  final String? password;
  final String? role; // Nếu role là tùy chọn
  final String? deviceId; // Nếu deviceId là tùy chọn

  LoginRequest({
    this.email,
    this.phone,
    this.password,
    this.role,
    this.deviceId,
  });

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);

  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}
