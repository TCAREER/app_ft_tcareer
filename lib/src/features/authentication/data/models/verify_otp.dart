enum TypeVerify { register, forgotPassword }

class VerifyOTP {
  String phoneNumber;
  String verificationId;
  TypeVerify type;
  VerifyOTP(this.phoneNumber, this.verificationId, this.type);
}
