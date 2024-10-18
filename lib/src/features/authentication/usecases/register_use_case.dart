import 'package:app_tcareer/src/features/authentication/data/models/register_request.dart';
import 'package:app_tcareer/src/features/authentication/data/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twilio_flutter/twilio_flutter.dart';

class RegisterUseCase {
  final AuthRepository authRepository;

  RegisterUseCase(this.authRepository);

  Future<void> register(RegisterRequest body) async {
    return await authRepository.register(body);
  }

  Future<void> checkUserPhone(String phone) async =>
      await authRepository.postCheckUserPhone(phone);

  Future<void> verifyPhoneNumber(
          {required String phoneNumber,
          required void Function(PhoneAuthCredential phoneAuthCredential)
              verificationCompleted,
          required void Function(FirebaseAuthException firebaseAuthException)
              verificationFailed,
          required void Function(
                  String verificationId, int? forceResendingToken)
              codeSent,
          required void Function(String verificationId)
              codeAutoRetrievalTimeout}) async =>
      await authRepository.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);

  Future<void> signInWithOTP(
          {required String smsCode, required String verificationId}) async =>
      await authRepository.signInWithOTP(
          smsCode: smsCode, verificationId: verificationId);

  Future<TwilioResponse> sendVerificationCode(String phoneNumber) async =>
      await authRepository.sendVerificationCode(phoneNumber);
  Future<TwilioResponse> verifyCode(
          {required String phoneNumber, required String code}) async =>
      await authRepository.verifyCode(phoneNumber: phoneNumber, code: code);
}

final registerUseCase =
    Provider((ref) => RegisterUseCase(ref.watch(authRepository)));
