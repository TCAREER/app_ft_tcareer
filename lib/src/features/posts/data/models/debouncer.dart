import 'dart:async';
import 'dart:ui';

class Debouncer {
  final int milliseconds;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  void run(VoidCallback action) {
    _timer?.cancel();  // Hủy Timer trước đó nếu đang chạy
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }


}
