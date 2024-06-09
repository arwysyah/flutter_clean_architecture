import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    log(
      '--> ${options.method.toUpperCase()} ${(options.baseUrl) + options.path}',
    );
    log(
      '--> ${options.headers}',
    );
    log(
      '--> ${options.data}',
    );
    return super.onRequest(options, handler);
  }

  @override
  Future onResponse(
      Response response, ResponseInterceptorHandler handler) async {
    response.headers.forEach(
      (k, v) => log('$k: $v'),
    );
    log(
      'response --> ${response.data}',
    );
    return super.onResponse(response, handler);
  }

  @override
  Future onError(DioError err, ErrorInterceptorHandler handler) async {
    log(
      'ERROR[${err.response?.statusCode}] => PATH: '
      'ERROR[${err.response?.data}]'
      '${err.requestOptions.path}',
    );

    return super.onError(err, handler);
  }
}
