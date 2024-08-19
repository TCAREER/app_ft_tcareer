import 'package:flutter/material.dart';

Widget searchBarWidget() {
  return SizedBox(
    height: 40,
    child: TextField(
      readOnly: true,
      decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          hintText: "Tìm kiếm",
          prefixIcon: Icon(Icons.search),
          fillColor: Color(0xffEEF3F8),
          filled: true,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide.none)),
    ),
  );
}
