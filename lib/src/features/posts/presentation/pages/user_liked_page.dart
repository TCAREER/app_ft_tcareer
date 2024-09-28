import 'package:app_tcareer/src/configs/app_colors.dart';
import 'package:app_tcareer/src/features/posts/presentation/posts_provider.dart';
import 'package:app_tcareer/src/widgets/circular_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class UserLikedPage extends ConsumerStatefulWidget {
 final  int postId;
  const UserLikedPage(this.postId, {super.key});

  @override
  ConsumerState<UserLikedPage> createState() => _UserLikedPageState();
}

class _UserLikedPageState extends ConsumerState<UserLikedPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask((){
      ref.read(postControllerProvider).getUserLikePost(widget.postId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(postControllerProvider);
    return ClipRRect(
      borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      child: ListView(
        children: [
          AppBar(
            centerTitle: true,
            automaticallyImplyLeading: false,
            title: Column(

              children: [
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(5)),
                  width: 30,
                  height: 4,
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
          Visibility(
            visible: controller.userLiked!=null,
            replacement: circularLoadingWidget(),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 10),
              itemCount: controller.userLiked?.data?.length??0,
              itemBuilder: (context, index) {
                final user = controller.userLiked?.data?[index];
                return ListTile(
                  onTap: () => context.pushNamed('profile',queryParameters: {"userId":user?.id.toString()}),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(user?.avatar??"https://ui-avatars.com/api/?name=${user?.fullName}&background=random"),
                  ),
                  title: Text(user?.fullName??""),
                  trailing:SizedBox(
                    height: 30,
                    width: 110,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: (){},
                      child: const Text("Theo dõi", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) => const SizedBox(height: 10,),
            ),
          ),
        ],
      ),


    );
  }
}