import 'package:app_tcareer/src/configs/app_constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twilio_flutter/twilio_flutter.dart';

class TwilioService {
  final TwilioFlutter twilioFlutter = TwilioFlutter(
    accountSid:
        "ACb84a4badc61503296b64b8b032db496d", // replace with Account SID
    authToken: AppConstants.twilioAuthToken, // replace with Auth Token
    twilioNumber: "+84", // replace with Twilio Number(With country code)
  );

  Future<TwilioResponse> sendVerificationCode(String phoneNumber) async {
    TwilioResponse response = await twilioFlutter.sendVerificationCode(
        verificationServiceId: "VAa60e455052ed95e037baaae39a7f2fcb",
        recipient: phoneNumber,
        verificationChannel: VerificationChannel.SMS);
    return response;
  }

  Future<TwilioResponse> verifyCode(
      {required String phoneNumber, required String code}) async {
    TwilioResponse response = await twilioFlutter.verifyCode(
        verificationServiceId: "VAa60e455052ed95e037baaae39a7f2fcb",
        recipient: phoneNumber,
        code: code);
    return response;
  }
}

final twilioService = Provider((ref) => TwilioService());
