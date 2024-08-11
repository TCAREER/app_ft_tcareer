import 'package:json_annotation/json_annotation.dart';

part 'register_request.g.dart'; // File này sẽ được tạo tự động sau khi chạy build_runner

@JsonSerializable()
class RegisterRequest {
  final String? email;
  final String? phone;
  final String? password;
  final String? name;

  RegisterRequest({
    this.email,
    this.phone,
    this.password,
    this.name,
  });

  factory RegisterRequest.fromJson(Map<String, dynamic> json) =>
      _$RegisterRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterRequestToJson(this);
}
