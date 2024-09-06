import 'package:app_tcareer/src/modules/home/data/models/post_response.dart';
import 'package:app_tcareer/src/modules/home/usecases/post_use_case.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

class PostState {
  final bool isLoading;
  final PostResponse? postData;
  final List<PostResponse>? postListData;
  final String? errorMessage;

  PostState({
    this.isLoading = false,
    this.postData,
    this.postListData,
    this.errorMessage,
  });

  PostState copyWith({
    bool? isLoading,
    PostResponse? postData,
    List<PostResponse>? postListData,
    String? errorMessage,
  }) {
    return PostState(
      isLoading: isLoading ?? this.isLoading,
      postData: postData ?? this.postData,
      postListData: postListData ?? this.postListData,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class PostController extends StateNotifier<PostState> {
  final PostUseCase postUseCase;
  PostController(this.postUseCase) : super(PostState());

  Future<void> getPost() async {
    state = state.copyWith(isLoading: true);
    final data = await postUseCase.getPost();
    state = state.copyWith(isLoading: false, postData: data);
  }

  Future<void> sharePost({required String url, required String title}) async {
    await Share.share(url, subject: title);
  }
}

// Đổi tên StateNotifier từ void sang AsyncValue<PostResponse>
// class PostController extends StateNotifier<AsyncValue<PostResponse>> {
//   final PostUseCase postUseCase;
//
//   PostController(this.postUseCase) : super(const AsyncValue.loading());
//
//   Future<void> getPosts() async {
//     try {
//       final postData = await postUseCase.getPost();
//       state = AsyncValue.data(postData);
//     } catch (error, stackTrace) {
//       state = AsyncValue.error(error, stackTrace);
//     }
//   }
// }

// final postControllerProvider = FutureProvider<PostResponse>((ref) async {
//   final postUseCase = ref.read(postUseCaseProvider);
//   return await postUseCase.getPost();
// });
final postControllerProvider =
    StateNotifierProvider<PostController, PostState>((ref) {
  final postUseCase = ref.read(postUseCaseProvider);
  return PostController(postUseCase);
});
