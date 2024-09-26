import 'package:app_tcareer/src/features/posts/presentation/posts_provider.dart';
import 'package:app_tcareer/src/features/posts/presentation/widgets/search_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SearchPage extends ConsumerWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final controller = ref.watch(searchPostControllerProvider);
    return PopScope(
      onPopInvoked: (didPop){
        controller.quickSearchData.data?.clear();
        controller.queryController.clear();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: false,
          leadingWidth: 40,
          automaticallyImplyLeading: false,
          title: searchBarWidget(controller: controller.queryController,onChanged: (val)async=>await controller.onSearch()),
          leading:GestureDetector(
            onTap: ()=>context.pop(),
            child: const Icon(Icons.arrow_back,color: Colors.black,),
          ),
        ),
        body: userList(ref),
      ),
    );
  }

  Widget userList(WidgetRef ref){
    final controller = ref.watch(searchPostControllerProvider);
    return Visibility(
      visible: controller.quickSearchData.data?.isNotEmpty==true,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 10),
        itemCount: controller.quickSearchData.data?.length??0,
          itemBuilder: (context, index) {
            final user = controller.quickSearchData.data?[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(user?.avatar??"https://ui-avatars.com/api/?name=${user?.fullName}&background=random"),
              ),
              title: Text(user?.fullName??""),
            );
          },
          separatorBuilder: (context, index) => const SizedBox(height: 10,),
      ),
    );
  }


}
