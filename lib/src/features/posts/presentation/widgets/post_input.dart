import 'package:flutter/material.dart';

Widget postInput(TextEditingController controller,
    {int? minLines, int? maxLines}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10),
    child: TextField(
      textInputAction: TextInputAction.done,
      autofocus: true,
      minLines: minLines,
      maxLines: maxLines,
      controller: controller,
      // Gán focusNode vào TextField
      keyboardType: TextInputType.multiline,
      decoration: const InputDecoration(
          hintText: "Hôm nay bạn muốn chia sẻ điều gì?",
          border: InputBorder.none,
          errorBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none),
    ),
  );
}
