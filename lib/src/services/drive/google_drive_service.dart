import 'dart:convert';
import 'dart:io' as io;

import 'package:app_tcareer/src/configs/app_constants.dart';
import 'package:flutter/services.dart';
import 'package:googleapis/drive/v3.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

const _scopes = [DriveApi.driveScope];

class GoogleDriveService {
  final _driveApi = _createDriveApi();

  GoogleDriveService();

  static Future<DriveApi> _createDriveApi() async {
    final credentials = await loadCredentials();
    final client = await clientViaServiceAccount(credentials, _scopes);
    return DriveApi(client);
  }

  static Future<ServiceAccountCredentials> loadCredentials() async {
    final jsonString =
        await rootBundle.loadString('assets/json/credentials.json');
    final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
    return ServiceAccountCredentials.fromJson(jsonMap);
  }

  Future<String> uploadFile(
      io.File file, String topic, String folderName) async {
    final driveApi = await _driveApi;

    const parentFolderId = "18KYXb729bytijEE6dqDIJf2NWOAoruzE";

    final topicFolderId =
        await getOrCreateFolderId(driveApi, topic, parentFolderId);
    if (topicFolderId == null) {
      throw Exception("Could not create or find the topic folder.");
    }

    final folderId =
        await getOrCreateFolderId(driveApi, folderName, topicFolderId);
    if (folderId == null) {
      throw Exception("Could not create the folderName folder.");
    }

    final uuid = Uuid();
    final fileName = uuid.v4();

    final fileContent = await file.readAsBytes();
    final media = Media(Stream.fromIterable([fileContent]), fileContent.length);

    final driveFile = File()
      ..name = fileName
      ..mimeType = 'application/octet-stream'
      ..parents = [folderId];

    try {
      final response =
          await driveApi.files.create(driveFile, uploadMedia: media);
      final fileId = response.id;

      // Cập nhật quyền chia sẻ của tệp để công khai
      if (fileId != null) {
        await updateFilePermissions(driveApi, fileId);

        // Tạo liên kết web content
        final fileUrl = 'https://drive.google.com/uc?export=view&id=$fileId';
        return fileUrl;
      } else {
        throw Exception("Failed to get file ID after upload.");
      }
    } catch (e) {
      throw Exception("Error uploading file: $e");
    }
  }

  Future<void> updateFilePermissions(DriveApi driveApi, String fileId) async {
    final permission = Permission()
      ..type = 'anyone'
      ..role = 'reader';

    try {
      await driveApi.permissions.create(permission, fileId);
    } catch (e) {
      throw Exception("Error updating file permissions: $e");
    }
  }

  Future<String?> getOrCreateFolderId(
      DriveApi driveApi, String folderName, String? parentId) async {
    final query = parentId == null
        ? "mimeType='application/vnd.google-apps.folder' and name='$folderName' and trashed=false"
        : "mimeType='application/vnd.google-apps.folder' and name='$folderName' and '$parentId' in parents and trashed=false";

    final results = await driveApi.files.list(
      q: query,
      spaces: 'drive',
    );

    if (results.files?.isNotEmpty == true) {
      return results.files?.first.id;
    }

    final folderMetadata = File()
      ..name = folderName
      ..mimeType = 'application/vnd.google-apps.folder'
      ..parents = parentId != null ? [parentId] : [];

    final folder = await driveApi.files.create(folderMetadata);
    return folder.id;
  }
}

final googleDriveServiceProvider = Provider<GoogleDriveService>((ref) {
  return GoogleDriveService();
});
