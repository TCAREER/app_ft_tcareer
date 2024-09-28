import 'package:app_tcareer/src/features/user/presentation/controllers/another_user_controller.dart';
import 'package:app_tcareer/src/features/user/presentation/controllers/user_connection_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class AnotherMenu extends ConsumerWidget {

  const AnotherMenu({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final controller = ref.watch(userConnectionControllerProvider);
    final anotherUser = ref.watch(anotherUserControllerProvider);
    return  ClipRRect(
      borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          children: [

            ListTile(
              onTap: ()=>controller.postAddFriend(anotherUser.anotherUserData?.data?.id.toString()??""),
              trailing: const PhosphorIcon(PhosphorIconsLight.userCirclePlus,color: Colors.black,),
              title: const Text("Kết nối",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 14),),
            ),
            const ListTile(
              trailing: PhosphorIcon(PhosphorIconsLight.flag,color: Colors.black,),
              title: Text("Báo cáo",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 14),),
            ),
            const ListTile(
              trailing: Icon(Icons.no_accounts_outlined,color: Colors.red,),
              title: Text("Chặn",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 14,color: Colors.red),),
            ),

          ],
        ),
      ),
    );
  }
}
