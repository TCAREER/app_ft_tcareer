import 'package:app_tcareer/src/modules/posts/presentation/widgets/post_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class PostDetailPage extends ConsumerWidget {
  const PostDetailPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text("Bài viết"),
        titleTextStyle: TextStyle(fontWeight: FontWeight.bold),
        leading: IconButton(
            onPressed: () => context.goNamed('home'),
            icon: Icon(Icons.arrow_back)),
      ),
      body: ListView(
        children: [
          postWidget(
              context: context,
              ref: ref,
              avatarUrl:
                  "https://scontent.fsgn8-2.fna.fbcdn.net/v/t39.30808-1/411923126_1432349927718063_233953190280512047_n.jpg?stp=dst-jpg_s200x200&_nc_cat=105&ccb=1-7&_nc_sid=0ecb9b&_nc_ohc=xtU3bXn9ChMQ7kNvgGuD95D&_nc_ht=scontent.fsgn8-2.fna&_nc_gid=ApDItnDZE_5SHbIVLadWcxl&oh=00_AYCILSiSE7IH7V_HOdHIry1dulHP94uKVruWxfRJAb3d9g&oe=66E052C4",
              userName: "Quang Thiện",
              subName: "flutter",
              createdAt: "1 giờ",
              content:
                  "Hôm trước thấy có bạn hỏi về việc làm sao để có thể play video nhanh được như tiktok. Mình cũng có bình luận trong đó thì thấy có một vài ae cũng hỏi một số vấn đề.",
              imageUrl:
                  "https://images.unsplash.com/photo-1719937206220-f7c76cc23d78?q=80&w=1770&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
              likes: "1",
              comments: "",
              shares: "",
              postId: ""),
        ],
      ),
    );
  }
}
