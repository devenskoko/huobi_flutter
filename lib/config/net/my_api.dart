import 'dart:convert';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/cupertino.dart';
import 'http.dart';
import '../storage_manager.dart';
import 'package:web_socket_channel/io.dart';

final Http http = Http();
final HttpCDN httpcdn = HttpCDN();

class Http extends BaseHttp {
  @override
  void init() {
    options.baseUrl = 'https://api-aws.huobi.pro';
    interceptors
      ..add(ApiInterceptor())
      // cookie持久化 异步
      ..add(CookieManager(PersistCookieJar(ignoreExpires: true, storage: FileStorage(StorageManager.temporaryDirectory.path))));
  }
}

/// 玩Android API
class ApiInterceptor extends InterceptorsWrapper {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    debugPrint('---api-request--->url--> ${options.baseUrl}${options.path}' + ' queryParameters: ${options.queryParameters}');
    debugPrint('---api-request--->data--->${options.data}');
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // debugPrint('---api-response--->resp----->${response.data}');

    ResponseData respData = ResponseData.fromJson(response.data);
    if (respData.status == 'ok') {
      response.data = respData.data ?? respData.tick;
      return handler.resolve(response);
    } else {
      throw NotSuccessException.fromRespData(respData);
    }
    super.onResponse(response, handler);
  }
}

class ApiInterceptorCDN extends InterceptorsWrapper {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    debugPrint('---api-request--->url--> ${options.baseUrl}${options.path}' + ' queryParameters: ${options.queryParameters}');
    debugPrint('---api-request--->data--->${options.data}');
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // debugPrint('---api-response--->resp----->${response.data}');
    ResponseData respData = ResponseData.fromJson(json.decode(response.data));
    if (respData.status == 'ok') {
      response.data = respData.data;
    } else {
      throw NotSuccessException.fromRespData(respData);
    }
  }
}

class ResponseData extends BaseResponseData {
  bool get success => 'ok' == status;

  ResponseData.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'];
    tick = json['tick'];
    ts = json['ts'];
    ch = json['ch'];
  }
}

class HttpCDN extends BaseHttp {
  @override
  void init() {
    options.baseUrl = '';
    interceptors..add(ApiInterceptorCDN());
  }
}

// 行情socket
class SocketClient {
  static late IOWebSocketChannel channel;

  SocketClient.create() {
    SocketClient.channel = IOWebSocketChannel.connect('wss://api.huobi.pro/ws');
  }
}
