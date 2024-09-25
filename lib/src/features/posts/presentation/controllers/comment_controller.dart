import 'dart:async';
import 'dart:io';

import 'package:app_tcareer/src/configs/app_constants.dart';
import 'package:app_tcareer/src/features/posts/presentation/posts_provider.dart';
import 'package:app_tcareer/src/features/posts/usecases/comment_use_case.dart';
import 'package:app_tcareer/src/features/posts/usecases/media_use_case.dart';
import 'package:app_tcareer/src/features/posts/usecases/post_use_case.dart';
import 'package:app_tcareer/src/utils/app_utils.dart';
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
  bool isDisposed = false;
  StreamSubscription? commentSubscription;
  CommentController(
      this.postUseCase, this.ref, this.commentUseCase, this.mediaUseCase);
  TextEditingController contentController = TextEditingController();

  Future<void> postCreateComment({
    required int postId,
    required BuildContext context,
  }) async {
    if (isDisposed) return; // Kiểm tra xem controller đã bị dispose chưa

    final mediaController = ref.watch(mediaControllerProvider);
    if (mediaController.videoPaths != null) {
      await AppUtils.loadingApi(() async => await uploadVideo(), context);
    }

    if (mediaController.imagePaths.isNotEmpty) {
      await AppUtils.loadingApi(() async => await uploadImageFile(), context);
    }
    await postUseCase.postCreateComment(
      postId: postId,
      content: contentController.text,
      parentId: parentId,
      mediaUrl: mediaUrl,
    );
    FocusScope.of(context).unfocus();
    contentController.clear();
    clearRepComment();
    mediaController.removeAssets(); // Chỉ gọi clear nếu chưa dispose
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
    commentData = await commentUseCase.getCommentByPostId(postId);

    notifyListeners();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    isDisposed = true;
    commentSubscription?.cancel();
    contentController.dispose();
    commentVisibility.clear();
    super.dispose();
  }

  // void listenToComments(String postId) {
  //   commentSubscription =
  //       commentUseCase.listenToComment(postId).listen((event) {
  //     if (event.snapshot.value != null) {
  //       commentData = event.snapshot.value as Map<dynamic, dynamic>;
  //     }
  //   });
  // }
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

  Stream<Map<dynamic, dynamic>> commentsStream(String postId) {
    return commentUseCase.listenToComment(postId).map((event) {
      if (event.snapshot.value != null) {
        final commentMap = event.snapshot.value as Map<dynamic, dynamic>;

        print(">>>>>>>>>>>>>>data: $commentMap"); // Kiểm tra dữ liệu

        // Sắp xếp bình luận
        final sortedComments = commentMap.entries.toList()
          ..sort((a, b) {
            final createdA = DateTime.tryParse(a.value['created_at']);
            final createdB = DateTime.tryParse(b.value['created_at']);
            return (createdB ?? DateTime.now())
                .compareTo(createdA ?? DateTime.now());
          });

        // Tạo bản đồ đã sắp xếp
        return {for (var e in sortedComments) e.key: e.value};
      } else {
        return {};
      }
    });
  }

  Future<void> pickMedia() async {
    await mediaUseCase.pickMediaWeb();
  }

  void clearRepComment() {
    userName = null;
    parentId = null;

    notifyListeners();
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
    String videoUrl = "${AppConstants.driveUrl}$videoId";
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

  Map<int, bool> commentVisibility = {};

  void toggleCommentVisibility(int commentId) {
    commentVisibility[commentId] = !(commentVisibility[commentId] ?? false);
    notifyListeners();
  }

  bool isLiking = false;
  Future<void> postLikeComment(String commentId) async {
    await commentUseCase.postLikeComment(commentId);
    // await Future.delayed(Duration(milliseconds: 300));
  }

  Stream<Map<dynamic, dynamic>> likeCommentsStream(String postId) {
    return commentUseCase.listenToLikeComment(postId).map((event) {
      if (event.snapshot.value != null) {
        final likesComment = event.snapshot.value as Map<dynamic, dynamic>;

        // Sắp xếp bình luận

        // Tạo bản đồ đã sắp xếp
        return likesComment;
      } else {
        return {};
      }
    });
  }
}


