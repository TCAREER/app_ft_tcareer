import 'package:flutter/material.dart';

Widget emptyWidget(String content) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          "assets/images/posts/empty.png",
          height: 30,
          width: 30,
        ),

        Text(
          content,
          style: TextStyle(fontSize: 10,color: Colors.black38),
        )
      ],
    ),
  );
}
