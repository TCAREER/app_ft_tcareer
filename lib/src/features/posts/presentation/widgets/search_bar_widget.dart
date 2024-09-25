import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget searchBarWidget({void Function(String)? onChanged,required TextEditingController controller}) {
  return SizedBox(
    height: 40,
    child: TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          hintText: "Tìm kiếm",
          prefixIcon: const Icon(
            Icons.search,
            color: Colors.black45,
          ),
          fillColor: Colors.grey.shade100,
          filled: true,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none)),
    ),
  );
}
