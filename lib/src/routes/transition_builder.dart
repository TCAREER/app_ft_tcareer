import 'package:flutter/material.dart';

FadeTransition fadeTransitionBuilder(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child) {
  return FadeTransition(
    opacity: CurveTween(curve: Curves.easeInOutCirc).animate(animation),
    child: child,
  );
}

SlideTransition slideUpTransitionBuilder(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child) {
  const begin = Offset(0.0, 1.0); // Bắt đầu từ dưới màn hình
  const end = Offset.zero; // Kết thúc ở vị trí hiện tại
  const curve = Curves.easeInOut; // Đường cong chuyển tiếp

  var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
  var offsetAnimation = animation.drive(tween);

  return SlideTransition(
    position: offsetAnimation,
    child: child,
  );
}
