import 'package:dio/dio.dart';

class ApiException {
  List<String> getExceptionMessage(DioException exception) {
    switch (exception.type) {
      case DioExceptionType.badResponse:
        return [
          "Lỗi phản hồi từ máy chủ",
          "Có thể do URL API không đúng hoặc dữ liệu gửi đi không hợp lệ."
        ];
      case DioExceptionType.connectionError:
        return [
          "Lỗi kết nối mạng",
          "Không thể kết nối tới máy chủ. Vui lòng kiểm tra kết nối mạng của bạn."
        ];
      case DioExceptionType.connectionTimeout:
        return [
          "Hết thời gian kết nối",
          "Lỗi kết nối. Vui lòng kiểm tra kết nối mạng hoặc thử lại sau."
        ];
      case DioExceptionType.cancel:
        return [
          "Yêu cầu bị hủy",
          "Yêu cầu của bạn đã bị hủy. Vui lòng kiểm tra lại."
        ];
      case DioExceptionType.receiveTimeout:
        return [
          "Hết thời gian nhận dữ liệu",
          "Lỗi nhận dữ liệu. Có thể do kết nối mạng kém hoặc máy chủ không phản hồi kịp thời."
        ];
      default:
        return [
          "Lỗi không xác định",
          "Đã xảy ra lỗi không rõ nguyên nhân. Vui lòng thử lại sau."
        ];
    }
  }

  List<String> getHttpStatusMessage(int statusCode) {
    switch (statusCode) {
      case 400:
        return ["Yêu cầu không hợp lệ", "Kiểm tra tham số yêu cầu."];
      case 401:
        return ["Có lỗi xảy ra", "Tên đăng nhập hoặc mật khẩu không đúng!"];
      case 403:
        return [
          "Không có quyền truy cập",
          "Bạn không có quyền thực hiện hành động này."
        ];
      case 404:
        return [
          "Tài nguyên không tìm thấy",
          "Kiểm tra URL API. Tài nguyên bạn tìm không tồn tại."
        ];
      case 500:
        return ["Lỗi máy chủ", "Máy chủ gặp lỗi. Vui lòng thử lại sau."];
      default:
        return [
          "Lỗi không xác định",
          "Vui lòng thử lại sau hoặc liên hệ với hỗ trợ."
        ];
    }
  }
}
