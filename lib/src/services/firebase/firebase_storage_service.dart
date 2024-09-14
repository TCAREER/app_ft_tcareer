import 'dart:io';
import 'dart:typed_data';

import 'package:app_tcareer/src/shared/utils/snackbar_utils.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

class FirebaseStorageService {
  final storage = FirebaseStorage.instance;

  Future<String> uploadFile(File file, String folderPath) async {
    final uuid = Uuid();
    String fileName = uuid.v4();
    String path = "$folderPath/$fileName";
    final ref = storage.ref().child(path);
    try {
      UploadTask uploadTask = ref.putFile(file);
      TaskSnapshot snapshot = await uploadTask;
      String url = await snapshot.ref.getDownloadURL();
      return url;
    } catch (e) {
      showSnackBarError("Có lỗi xảy ra, Vui lòng thử lại");
      rethrow;
    }
  }

  Future<String> uploadPreviewImage(Uint8List file, String folderPath) async {
    final uuid = Uuid();
    String fileName = uuid.v4();
    String path = "$folderPath/$fileName.jpg";
    final ref = FirebaseStorage.instance.ref().child(path);

    try {
      // Chỉ định loại MIME là image/jpeg hoặc image/png tùy thuộc vào loại ảnh
      UploadTask uploadTask = ref.putData(
        file,
        SettableMetadata(
            contentType:
                "image/jpg"), // Thay 'image/jpeg' bằng loại MIME của ảnh bạn đang tải lên
      );
      TaskSnapshot snapshot = await uploadTask;
      String url = await snapshot.ref.getDownloadURL();
      return url;
    } catch (e) {
      // Hiển thị thông báo lỗi nếu có
      showSnackBarError("Có lỗi xảy ra, Vui lòng thử lại");
      rethrow;
    }
  }
}

final firebaseStorageServiceProvider = Provider<FirebaseStorageService>((ref) {
  return FirebaseStorageService();
});
