import 'package:app_tcareer/src/features/posts/data/models/debouncer.dart';
import 'package:app_tcareer/src/features/posts/data/models/quick_search_user_data.dart';
import 'package:app_tcareer/src/features/posts/usecases/post_use_case.dart';
import 'package:app_tcareer/src/features/posts/usecases/search_use_case.dart';
import 'package:flutter/cupertino.dart';

class SearchPostController extends ChangeNotifier{
  final SearchUseCase searchUseCase;
  SearchPostController(this.searchUseCase);

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

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    queryController.dispose();

  }
}
