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
          prefixIcon: Icon(
            Icons.search,
            color: Colors.black45,
          ),
          fillColor: Color(0xffEBF2FA),
          filled: true,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none)),
    ),
  );
}
