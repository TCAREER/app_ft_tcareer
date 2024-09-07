import 'package:app_tcareer/src/configs/app_constants.dart';
import 'package:app_tcareer/src/modules/posts/data/models/post_response.dart';
import 'package:curl_logger_dio_interceptor/curl_logger_dio_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class PostRepository {
  final Ref ref;
  final dio = Dio();
  PostRepository(this.ref);
  Future<PostResponse> getPosts() async {
    dio.interceptors.add(CurlLoggerDioInterceptor(printOnSuccess: true));
    dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90));

    PostResponse? data;

    final response = await dio.get("https://newsapi.org/v2/everything",
        queryParameters: {
          "q": "tech",
          "sortBy": "publishedAt",
          "apiKey": AppConstants.apiPostKey
        });
    data = PostResponse.fromJson(response.data);
    return data;
  }
}

final postRepository = Provider((ref) => PostRepository(ref));
