import 'package:app_tcareer/src/modules/home/data/models/post_response.dart';
import 'package:app_tcareer/src/modules/home/usecases/post_use_case.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

final postControllerProvider = FutureProvider<PostResponse>((ref) async {
  final postUseCase = ref.read(postUseCaseProvider);
  return await postUseCase.getPost();
});
