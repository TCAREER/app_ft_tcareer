import 'dart:convert';

import 'package:app_tcareer/src/features/posts/data/models/debouncer.dart';
import 'package:app_tcareer/src/features/posts/data/models/posts_response.dart' as post;
import 'package:app_tcareer/src/features/posts/data/models/quick_search_user_data.dart';
import 'package:app_tcareer/src/features/posts/usecases/post_use_case.dart';
import 'package:app_tcareer/src/features/posts/usecases/search_use_case.dart';
import 'package:app_tcareer/src/features/user/data/models/users.dart' as user;
import 'package:flutter/cupertino.dart';

class SearchPostController extends ChangeNotifier{
  final SearchUseCase searchUseCase;
  final PostUseCase postUseCase;
  SearchPostController(this.searchUseCase,this.postUseCase);

  QuickSearchUserData quickSearchData = QuickSearchUserData();
  TextEditingController queryController = TextEditingController();
  final Debouncer debouncer = Debouncer(milliseconds: 1000);

  Future<void>quickSearchUser()async{
    quickSearchData = await searchUseCase.getQuickSearchUser(queryController.text);
    notifyListeners();
  }

  Future<void> onSearch()async{
    debouncer.run(()async{
      if(queryController.text.isNotEmpty){
        await quickSearchUser();
      }else{
        quickSearchData.data?.clear();
        notifyListeners();
      }
    });
  }
  post.PostsResponse postData = post.PostsResponse();

  bool isLoading = false;
  void setIsLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }
  Future<void>search(String query)async{
    setIsLoading(true);
   final data = await searchUseCase.getSearch(query);
   List<dynamic> userJson = data['users']['data'];
   await mapUserFromJson(userJson);

   List<dynamic>postJson = data['posts']['data'];
   await mapPostFromJson(postJson);
   setIsLoading(false);
    notifyListeners();
  }
  Future<void> postLikePost(
      {required int index, required String postId}) async {

    await postUseCase.postLikePost(postId: postId,index: index,postCache: posts);
    notifyListeners();
  }
  List<user.Data>users  = [];
  Future<void>mapUserFromJson(List<dynamic> userJson)async{
     users = userJson.whereType<Map<String,dynamic>>().map((item)=>user.Data.fromJson(item)).toList();
  }

  Future<void>mapPostFromJson(List<dynamic> postJson)async{

    posts = postJson.whereType<Map<String,dynamic>>().map((item)=>post.Data.fromJson(item)).toList();
  }
  List<post.Data>posts = [];
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    queryController.dispose();

  }
}
