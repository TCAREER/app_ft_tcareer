import 'package:flutter/material.dart';

Widget information(
    {required String fullName,
    String? expertise,
    String? follows,
    String? avatar,
    String? friends}) {
  return ListTile(
    title: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          fullName,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(
          expertise ?? "Người dùng",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
        ),
        const SizedBox(height: 10),
      ],
    ),
    subtitle: Row(
      children: [
        Text(
          follows != null ? "$follows người theo dõi" : "0 người theo dõi",
          style: const TextStyle(fontSize: 12, color: Colors.black54),
        ),
        const SizedBox(
          width: 15,
        ),
        Text(
          friends != null ? "$friends người bạn" : "0 người bạn",
          style: const TextStyle(fontSize: 12, color: Colors.black54),
        ),
      ],
    ),
    trailing: CircleAvatar(
      radius: 40,
      backgroundImage: NetworkImage(avatar ??
          "https://ui-avatars.com/api/?name=$fullName&background=random"),
    ),
  );
}
