import 'package:app_tcareer/src/configs/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class PostingPage extends ConsumerWidget {
  const PostingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: appBar(context),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(
                    "https://mighty.tools/mockmind-api/content/human/7.jpg"),
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Quang Thiện",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  objectWidget()
                ],
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          postInput()
        ],
      ),
      bottomNavigationBar: bottomAppBar(context),
    );
  }

  PreferredSizeWidget appBar(BuildContext context) {
    return AppBar(
      bottom: const PreferredSize(
        child: Divider(),
        preferredSize: Size.fromHeight(5),
      ),
      backgroundColor: Colors.white,
      leading: IconButton(
        onPressed: () => context.pop(),
        icon: const Icon(
          Icons.close,
          color: Colors.black,
        ),
      ),
      centerTitle: true,
      title: const Text("Tạo bài viết"),
      titleTextStyle: const TextStyle(
        color: Colors.black,
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  backgroundColor: AppColors.executeButton),
              onPressed: () {},
              child: const Text(
                "Đăng",
                style: TextStyle(color: Colors.white),
              )),
        )
      ],
    );
  }

  Widget objectWidget() {
    return const Row(
      children: [Text("Mọi người"), Icon(Icons.arrow_drop_down)],
    );
  }

  Widget postInput() {
    return const TextField(
      autofocus: true,
      maxLines: null,
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 10),
          hintText: "Hôm nay bạn muốn chia sẻ điều gì?",
          border: InputBorder.none,
          errorBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none),
    );
  }

  Widget bottomAppBar(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context), // Get the MediaQuery data
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100), // Animation duration
        curve: Curves.easeInOut, // Animation curve
        margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom *
                .95), // Adjust bottom margin based on keyboard height
        child: BottomAppBar(
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                  onPressed: () => context.pushNamed("photoManager"),
                  icon: const PhosphorIcon(
                    PhosphorIconsBold.image,
                    color: Colors.grey,
                    size: 30,
                  )),
              const SizedBox(
                width: 10,
              ),
              IconButton(
                  onPressed: () {},
                  icon: const PhosphorIcon(
                    PhosphorIconsBold.link,
                    color: Colors.grey,
                    size: 30,
                  )),
              const SizedBox(
                width: 10,
              ),
              IconButton(
                  onPressed: () {},
                  icon: const PhosphorIcon(
                    PhosphorIconsBold.smiley,
                    color: Colors.grey,
                    size: 30,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
