import 'package:app_tcareer/src/modules/posts/presentation/controllers/posting_controller.dart';
import 'package:flutter/material.dart';

import 'privacy_bottom_sheet_widget.dart';

Widget privacyWidget(PostingController controller, BuildContext context) {
  return GestureDetector(
    onTap: () => showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) => privacyBottomSheetWidget(context: context)),
    child: Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: Colors.grey.shade200),
      child: Visibility(
        visible: controller.selectedPrivacy.contains("Public"),
        replacement: const Row(
          children: [
            Icon(
              Icons.group,
              size: 15,
            ),
            SizedBox(
              width: 2,
            ),
            const Text(
              "Bạn bè",
              style: TextStyle(fontSize: 12),
            ),
            SizedBox(
              width: 5,
            ),
            Icon(
              Icons.arrow_drop_down,
              size: 15,
            ),
          ],
        ),
        child: const Row(
          children: [
            Icon(
              Icons.public,
              size: 15,
            ),
            const SizedBox(
              width: 2,
            ),
            Text(
              "Công khai",
              style: TextStyle(fontSize: 12),
            ),
            const SizedBox(
              width: 5,
            ),
            Icon(
              Icons.arrow_drop_down,
              size: 15,
            ),
          ],
        ),
      ),
    ),
  );
}
