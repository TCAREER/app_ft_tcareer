import 'package:app_tcareer/src/modules/posts/presentation/widgets/comment_item_widget.dart';
import 'package:flutter/material.dart';

class CommentsPage extends StatelessWidget {
  final ScrollController scrollController;
  const CommentsPage({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            appBar(),
            Divider(
              // thickness: 0.1,
              color: Colors.grey.shade200,
            ),
            Expanded(child: items())
          ],
        ),
        bottomNavigationBar: bottomAppBar(),
      ),
    );
  }

  Widget appBar() {
    return SizedBox(
      height: 50, // Kích thước của AppBar
      child: CustomScrollView(
        controller: scrollController,
        slivers: [
          SliverAppBar(
            elevation: 0.5,
            toolbarHeight: 50,
            automaticallyImplyLeading: false,
            centerTitle: true,
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
                const Text(
                  "Bình luận",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            pinned: true,
            expandedHeight: 100.0,
            flexibleSpace: const FlexibleSpaceBar(),
          ),
        ],
      ),
    );
  }

  Widget items() {
    return ListView.separated(
      itemCount: 20,
      itemBuilder: (context, index) {
        return commentItemWidget();
      },
      separatorBuilder: (context, index) => const SizedBox(
        height: 10,
      ),
    );
  }

  Widget commentInput() {
    return SizedBox(
      height: 45,
      child: TextField(
        decoration: InputDecoration(
          hintText: "Bình luận cho Quang Thiện",
          contentPadding:
              const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Colors.grey.shade200)),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Colors.grey.shade200)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Colors.grey.shade200)),
        ),
      ),
    );
  }

  Widget bottomAppBar() {
    return BottomAppBar(
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(
                      "https://mighty.tools/mockmind-api/content/human/39.jpg"),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 6,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                commentInput(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
