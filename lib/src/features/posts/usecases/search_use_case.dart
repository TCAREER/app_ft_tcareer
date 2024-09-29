import 'package:app_tcareer/src/features/posts/data/models/quick_search_user_data.dart';
import 'package:app_tcareer/src/features/posts/data/repositories/post_repository.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchUseCase {
  final PostRepository postRepository;
  SearchUseCase(this.postRepository);

  Future<QuickSearchUserData> getQuickSearchUser(String query) async =>
      await postRepository.getQuickSearchUser(query);

  Future getSearch(String query) async => await postRepository.getSearch(query);
}

final searchUseCaseProvider =
    Provider((ref) => SearchUseCase(ref.watch(postRepository)));
