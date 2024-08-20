import 'package:app_tcareer/src/modules/home/presentation/widgets/search_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          backgroundColor: Colors.white,
          // elevation: 2,
          leading: const Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(
                  "https://mighty.tools/mockmind-api/content/human/7.jpg"),
            ),
          ),
          centerTitle: true,
          title: searchBarWidget(),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: GestureDetector(
                child: const PhosphorIcon(
                  PhosphorIconsFill.chatCircleDots,
                  color: Colors.black,
                ),
              ),
            )
          ],
        ),
        body: ListView.separated(
          separatorBuilder: (context, index) => const SizedBox(
            height: 10,
          ),
          padding: const EdgeInsets.symmetric(vertical: 10),
          itemCount: 5,
          itemBuilder: (context, index) {
            return Container(
              color: Colors.white,
              padding: const EdgeInsets.all(4),
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 25,
                            backgroundImage: NetworkImage(
                                "https://mighty.tools/mockmind-api/content/human/49.jpg"),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Nguyễn Thị B",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Flutter developer - Katec",
                                style: TextStyle(color: Colors.black54),
                              ),
                              Text(
                                "1 giờ",
                                style: TextStyle(color: Colors.black54),
                              )
                            ],
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                          "Chi tiết về chip Tensor G4 trên Pixel 9: Hiệu năng vẫn kém, nhưng khắc phục được 1 thứ rất quan trọng của dòng Pixel😎"),
                      const SizedBox(
                        height: 10,
                      ),
                      Image.network(
                        "https://vatvostudio.vn/wp-content/uploads/2024/08/Gooogle-Tensor-G4.jpg",
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RichText(
                                text: TextSpan(children: [
                              WidgetSpan(
                                  child: Container(
                                padding: const EdgeInsets.all(3),
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle, color: Colors.blue),
                                child: const Icon(
                                  Icons.thumb_up,
                                  color: Colors.white,
                                  size: 10,
                                ),
                              )),
                              const TextSpan(
                                  text: " 116",
                                  style: TextStyle(
                                      color: Colors.black54, fontSize: 12))
                            ])),
                            RichText(
                                text: const TextSpan(
                                    text: "12 bình luận",
                                    style: TextStyle(
                                        color: Colors.black54, fontSize: 12),
                                    children: [
                                  WidgetSpan(
                                      child: SizedBox(
                                    width: 10,
                                  )),
                                  TextSpan(
                                      text: " 20 lượt chia sẻ",
                                      style: TextStyle(color: Colors.black54))
                                ])),
                          ],
                        ),
                      ),
                      // Divider(
                      //   height: 20,
                      //   color: Colors.grey.shade300,
                      // ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RichText(
                                text: const TextSpan(children: [
                              WidgetSpan(
                                  alignment: PlaceholderAlignment.middle,
                                  child: PhosphorIcon(
                                    PhosphorIconsRegular.thumbsUp,
                                    color: Colors.black54,
                                    size: 20,
                                  )),
                              TextSpan(
                                  text: " Thích",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      // fontWeight: FontWeight.w600,
                                      fontSize: 12))
                            ])),
                            RichText(
                                text: const TextSpan(children: [
                              WidgetSpan(
                                  alignment: PlaceholderAlignment.middle,
                                  child: PhosphorIcon(
                                    PhosphorIconsRegular.chatCircleDots,
                                    color: Colors.black54,
                                    size: 20,
                                  )),
                              TextSpan(
                                  text: " Bình luận",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      // fontWeight: FontWeight.w600,
                                      fontSize: 12))
                            ])),
                            RichText(
                                text: const TextSpan(children: [
                              WidgetSpan(
                                  alignment: PlaceholderAlignment.middle,
                                  child: PhosphorIcon(
                                    PhosphorIconsRegular.messengerLogo,
                                    color: Colors.black54,
                                    size: 20,
                                  )),
                              TextSpan(
                                  text: " Gửi",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      // fontWeight: FontWeight.w600,
                                      fontSize: 12))
                            ])),
                            RichText(
                                text: const TextSpan(children: [
                              WidgetSpan(
                                  alignment: PlaceholderAlignment.middle,
                                  child: PhosphorIcon(
                                    PhosphorIconsRegular.shareFat,
                                    color: Colors.black54,
                                    size: 20,
                                  )),
                              TextSpan(
                                  text: " Chia sẻ",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      // fontWeight: FontWeight.w600,
                                      fontSize: 12))
                            ])),
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            );
          },
        ));
  }
}
