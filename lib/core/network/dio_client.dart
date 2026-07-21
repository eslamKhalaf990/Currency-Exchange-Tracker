import 'package:currency_exchange_tracker/core/error/exceptions.dart';
import 'package:dio/dio.dart';
import 'logging_interceptor.dart';

class DioClient {
  final Dio _dio;

  DioClient(this._dio) {
    _dio
      ..options.connectTimeout = const Duration(seconds: 30)
      ..options.receiveTimeout = const Duration(seconds: 30)
      ..options.responseType = ResponseType.json
      ..interceptors.add(LoggingInterceptor());
  }

  Future<Response> get(
    String url, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response response = await _dio.get(
        url,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionError) {
        throw NetworkException('No internet connection. Please check your network and try again.');
      } else if (e.type == DioExceptionType.badResponse) {
        throw ServerException('Server error: ${e.response?.statusCode}. Please try again later.');
      } else {
        throw ServerException('Something went wrong. Please try again.');
      }
    } catch (e) {
      throw ServerException('An unexpected error occurred.');
    }
  }
}
