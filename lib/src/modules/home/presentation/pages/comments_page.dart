import 'package:app_tcareer/src/modules/home/presentation/widgets/comment_item_widget.dart';
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
}
