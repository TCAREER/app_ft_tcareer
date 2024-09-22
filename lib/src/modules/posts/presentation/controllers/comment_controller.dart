import 'dart:io';

import 'package:app_tcareer/src/configs/app_constants.dart';
import 'package:app_tcareer/src/modules/posts/presentation/posts_provider.dart';
import 'package:app_tcareer/src/modules/posts/usecases/comment_use_case.dart';
import 'package:app_tcareer/src/modules/posts/usecases/media_use_case.dart';
import 'package:app_tcareer/src/modules/posts/usecases/post_use_case.dart';
import 'package:app_tcareer/src/shared/utils/app_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

class CommentController extends ChangeNotifier {
  final PostUseCase postUseCase;
  final MediaUseCase mediaUseCase;
  final Ref ref;
  final CommentUseCase commentUseCase;
  CommentController(
      this.postUseCase, this.ref, this.commentUseCase, this.mediaUseCase);
  TextEditingController contentController = TextEditingController();

  Future<void> postCreateComment({
    required int postId,
    required BuildContext context,
  }) async {
    final mediaController = ref.watch(mediaControllerProvider);
    if (mediaController.videoPaths != null) {
      await uploadVideo();
    }
    if (mediaController.imagePaths.isNotEmpty) {
      await uploadImageFile();
    }
    await postUseCase.postCreateComment(
        postId: postId,
        content: contentController.text,
        parentId: parentId,
        mediaUrl: mediaUrl);
    contentController.clear();
    mediaController.removeAssets();
    clearRepComment();

    FocusScope.of(context).unfocus();
  }

  bool hasContent = false;
  void setHasContent(String value) {
    if (value.isNotEmpty) {
      hasContent = true;
    } else {
      hasContent = false;
    }
    notifyListeners();
  }

  String? userName;
  int? parentId;
  void setRepComment({required int commentId, required String fullName}) {
    parentId = null;
    userName = fullName;
    parentId = commentId;

    notifyListeners();
  }

  Map<dynamic, dynamic>? commentData;
  Future<void> getCommentByPostId(String postId) async {
    commentData?.clear();
    commentData = await commentUseCase.getCommentByPostId(postId);

    notifyListeners();
  }

  List<MapEntry<dynamic, dynamic>> getCommentChildren(
      int parentId, List<MapEntry<dynamic, dynamic>> commentData) {
    final directChildren = commentData
        .where((entry) => entry.value['parent_id'] == parentId)
        .toList();

    List<MapEntry<dynamic, dynamic>> allChildren = [];
    for (var child in directChildren) {
      allChildren.add(child);
      allChildren.addAll(getCommentChildren(int.parse(child.key), commentData));
    }
    return allChildren;
  }

  void listenToComments(String postId) {
    commentData?.clear();
    commentUseCase.listenToComment(postId).listen((event) {
      if (event.snapshot.value != null) {
        commentData = event.snapshot.value as Map<dynamic, dynamic>;
        notifyListeners();
      }
    });
  }

  Future<void> pickMedia() async {
    await mediaUseCase.pickMediaWeb();
  }

  void clearRepComment() {
    userName = null;
    parentId = null;
  }

  List<String> mediaUrl = [];
  Future<void> uploadVideo() async {
    mediaUrl.clear();
    final mediaController = ref.watch(mediaControllerProvider);
    final uuid = Uuid();
    final id = uuid.v4();
    String videoId = await postUseCase.uploadFile(
      topic: "Comments",
      folderName: id,
      file: File(mediaController.videoPaths ?? ""),
    );
    String videoUrl = "${AppConstants.driveUrl}$videoId?alt=media";
    mediaUrl.add(videoUrl);
  }

  Future<void> uploadImageFile() async {
    mediaUrl.clear();
    final mediaController = ref.watch(mediaControllerProvider);
    final uuid = Uuid();
    final id = uuid.v4();
    for (String asset in mediaController.imagePaths) {
      String? assetPath = await AppUtils.compressImage(asset);
      // String url = await postUseCase.uploadImage(
      //     file: File(assetPath ?? ""), folderPath: path);
      String url = await postUseCase.uploadFileFireBase(
          file: File(assetPath ?? ""), folderPath: "Comments/$id");
      mediaUrl.add(url);
    }
    // notifyListeners();
  }
}

final commentControllerProvider = ChangeNotifierProvider((ref) {
  final postUseCase = ref.read(postUseCaseProvider);
  final commentUseCase = ref.read(commentUseCaseProvider);
  final mediaUseCase = ref.read(mediaUseCaseProvider);
  return CommentController(postUseCase, ref, commentUseCase, mediaUseCase);
});
