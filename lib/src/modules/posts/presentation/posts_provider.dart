import 'package:app_tcareer/src/modules/posts/data/models/media_state.dart';
import 'package:app_tcareer/src/modules/posts/data/models/post_state.dart';
import 'package:app_tcareer/src/modules/posts/presentation/controllers/media_controller.dart';
import 'package:app_tcareer/src/modules/posts/presentation/controllers/posting_controller.dart';
import 'package:app_tcareer/src/modules/posts/usecases/media_use_case.dart';
import 'package:app_tcareer/src/modules/posts/usecases/post_use_case.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'controllers/post_controller.dart';

final postControllerProvider = ChangeNotifierProvider((ref) {
  final postUseCase = ref.read(postUseCaseProvider);
  return PostController(postUseCase, ref);
});

final postingControllerProvider = ChangeNotifierProvider((ref) {
  final postUseCase = ref.read(postUseCaseProvider);
  return PostingController(postUseCase, ref);
});

final mediaControllerProvider = ChangeNotifierProvider((ref) {
  final mediaUseCase = ref.read(mediaUseCaseProvider);
  return MediaController(mediaUseCase, ref);
});
