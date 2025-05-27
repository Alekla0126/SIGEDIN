import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http_interceptor.dart';

class AuthInterceptor implements InterceptorContract {
  final String? token;

  AuthInterceptor({this.token});

  @override
  Future<BaseRequest> interceptRequest({required BaseRequest request}) async {
    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }
    return request;
  }

  @override
  Future<BaseResponse> interceptResponse({required BaseResponse response}) async {
    return response;
  }

  @override
  Future<bool> shouldInterceptRequest() => Future.value(true);

  @override
  Future<bool> shouldInterceptResponse() => Future.value(false);
}

class LoggingInterceptor implements InterceptorContract {
  @override
  Future<BaseRequest> interceptRequest({required BaseRequest request}) async {
    print('--> ${request.method} ${request.url}');
    print('Headers: ${request.headers}');
    if (request is http.Request) {
      print('Body: ${request.body}');
    }
    print('--> END ${request.method}');
    return request;
  }

  @override
  Future<BaseResponse> interceptResponse({required BaseResponse response}) async {
    print('<-- ${response.statusCode} ${response.request?.url}');
    print('Headers: ${response.headers}');
    if (response is http.Response) {
      print('Body: ${response.body}');
    }
    print('<-- END HTTP');
    return response;
  }

  @override
  Future<bool> shouldInterceptRequest() => Future.value(kDebugMode);

  @override
  Future<bool> shouldInterceptResponse() => Future.value(kDebugMode);
}
