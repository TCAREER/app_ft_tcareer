import 'package:json_annotation/json_annotation.dart';

part 'login_response.g.dart'; // File này sẽ được tạo tự động sau khi chạy build_runner

@JsonSerializable()
class LoginResponse {
  final String? accessToken;
  final String? refreshToken;
  final String? tokenType;
  final int? expireIn;
  LoginResponse(
      {this.accessToken, this.refreshToken, this.tokenType, this.expireIn});

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}
