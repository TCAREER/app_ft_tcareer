import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ConversationPage extends StatelessWidget {
  const ConversationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [sliverAppBar(context), sliverFriend(), sliverChat()],
      ),
    );
  }

  Widget sliverAppBar(BuildContext context) {
    // final postingController = ref.watch(postingControllerProvider);
    return SliverAppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () => context.goNamed("home"),
      ),
      centerTitle: true,
      backgroundColor: Colors.white,
      floating: true,
      pinned: false, // AppBar không cố định
      title: const Text(
        "Đoạn chat",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
      ),
      // leadingWidth: 120,
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: GestureDetector(
            onTap: () {},
            child: const PhosphorIcon(
              PhosphorIconsRegular.magnifyingGlass,
              color: Colors.black,
              size: 20,
            ),
          ),
        ),
      ],
      // bottom: PreferredSize(
      //   preferredSize: postingController.isLoading == true
      //       ? const Size.fromHeight(30)
      //       : const Size.fromHeight(0),
      //   child: postingLoading(ref),
      // ),
    );
  }

  Widget sliverChat() {
    return SliverList(
        delegate: SliverChildBuilderDelegate(
      childCount: 5,
      (context, index) {
        return ListTile(
          onTap: () => context.goNamed("chat"),
          leading: CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage(
                "https://mighty.tools/mockmind-api/content/human/57.jpg"),
          ),
          title: Text("Quang Thiện"),
          subtitle: Text(
            "Bạn: Xin chào",
            style: TextStyle(fontSize: 12, color: Colors.black54),
          ),
          trailing: Text("1 phút"),
        );
      },
    ));
  }

  Widget sliverFriend() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: SizedBox(
          height: 100, // Đặt chiều cao cho hàng bạn bè
          child: ListView.builder(
            scrollDirection: Axis.horizontal, // Cuộn theo chiều ngang
            itemCount: 5,
            itemBuilder: (context, index) {
              return Container(
                width: 70, // Đặt chiều rộng cho mỗi avatar
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(
                          "https://mighty.tools/mockmind-api/content/human/57.jpg"),
                    ),
                    const SizedBox(height: 5),
                    Text("Bạn $index"), // Thay đổi tên người bạn
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
