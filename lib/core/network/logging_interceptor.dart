import 'package:dio/dio.dart';
import 'package:currency_exchange_tracker/core/util/dev_log.dart';

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    DevLog.logRequest(options.uri.toString(), params: options.queryParameters);
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    DevLog.logResponse(response.requestOptions.uri.toString(), response.data.toString());
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    DevLog.logError(err.requestOptions.uri.toString(), err.message);
    super.onError(err, handler);
  }
}
