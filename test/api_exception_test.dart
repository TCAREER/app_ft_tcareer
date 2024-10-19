import 'package:app_tcareer/src/configs/exceptions/api_exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:mockito/mockito.dart';

class MockDioException extends Mock implements DioException {}

void main() {
  late ApiException apiException;

  setUp(() {
    apiException = ApiException();
  });

  group('ApiException Tests', () {
    test('Test bad response exception', () {
      final exception = MockDioException();
      when(exception.type).thenReturn(DioExceptionType.badResponse);

      final messages = apiException.getExceptionMessage(exception);
      expect(messages, ["Lỗi phản hồi", "URL API hoặc dữ liệu không hợp lệ."]);
    });

    test('Test connection error', () {
      final exception = MockDioException();
      when(exception.type).thenReturn(DioExceptionType.connectionError);

      final messages = apiException.getExceptionMessage(exception);
      expect(messages, ["Lỗi kết nối", "Kiểm tra kết nối mạng."]);
    });

    test('Test connection timeout', () {
      final exception = MockDioException();
      when(exception.type).thenReturn(DioExceptionType.connectionTimeout);

      final messages = apiException.getExceptionMessage(exception);
      expect(messages, ["Hết thời gian kết nối", "Kiểm tra lại kết nối."]);
    });

    test('Test cancel exception', () {
      final exception = MockDioException();
      when(exception.type).thenReturn(DioExceptionType.cancel);

      final messages = apiException.getExceptionMessage(exception);
      expect(messages, ["Yêu cầu bị hủy", "Kiểm tra lại yêu cầu."]);
    });

    test('Test receive timeout exception', () {
      final exception = MockDioException();
      when(exception.type).thenReturn(DioExceptionType.receiveTimeout);

      final messages = apiException.getExceptionMessage(exception);
      expect(
          messages, ["Hết thời gian nhận dữ liệu", "Kiểm tra kết nối mạng."]);
    });

    // test('Test undefined exception', () {
    //   final exception = MockDioException();
    //   when(exception.type).thenReturn(DioExceptionType.other);
    //
    //   final messages = apiException.getExceptionMessage(exception);
    //   expect(messages, ["Lỗi không xác định", "Vui lòng thử lại sau."]);
    // });
  });
}
