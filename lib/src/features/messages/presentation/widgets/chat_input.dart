import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Widget chatInput(WidgetRef ref, BuildContext context) {
  // final controller = ref.watch(commentControllerProvider);

  return Column(
    mainAxisAlignment: MainAxisAlignment.end,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      TextField(
        style: TextStyle(fontSize: 12),
        textAlignVertical: TextAlignVertical.center,
        onChanged: (val) {},
        keyboardType: TextInputType.multiline,
        maxLines: null,
        decoration: InputDecoration(
          suffix: GestureDetector(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.all(
                  3), // Thêm padding để làm cho nút đẹp hơn
              decoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_forward_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
          hintText: "Nhập tin nhắn...",
          hintStyle: TextStyle(fontSize: 12),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
    ],
  );
}
