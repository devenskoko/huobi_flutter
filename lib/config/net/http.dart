import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/adapter.dart';
import 'package:dio/native_imp.dart';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:huobi_flutter/utils/platform_utils.dart';

export 'package:dio/dio.dart';

// 必须是顶层函数
_parseAndDecode(String response) {
  return jsonDecode(response);
}

parseJson(String text) {
  return compute(_parseAndDecode, text);
}

abstract class BaseHttp extends DioForNative {
  BaseHttp() {
    /// 初始化 加入app通用处理
    (transformer as DefaultTransformer).jsonDecodeCallback = parseJson;
    interceptors..add(HeaderInterceptor());
    // 配置代理
    // (httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (HttpClient client) {
    //   client.findProxy = (uri) {
    //     return 'PROXY 127.0.0.1:1087';
    //   };
    //   client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    // };
    init();
  }

  void init();
}

/// 添加常用Header
class HeaderInterceptor extends InterceptorsWrapper {
  static String appVersion = '';

  @override
  onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    options.connectTimeout = 1000 * 45;
    options.receiveTimeout = 1000 * 45;

    if (appVersion == '') {
      appVersion = await PlatformUtils.getAppVersion();
    }

    var version = Map()
      ..addAll({
        'appVerison': appVersion,
      });
    options.headers['version'] = version;
    options.headers['platform'] = Platform.operatingSystem;
    handler.next(options);
  }
}

/// 子类需要重写
abstract class BaseResponseData {
  String status;
  dynamic data;
  int? ts;
  String? ch;
  Map? tick;

  bool get success;

  BaseResponseData({this.status = 'ok', this.data, this.ts, this.ch, this.tick});

  @override
  String toString() {
    return 'BaseRespData{status: $status, data: $data}';
  }
}

/// 接口的code没有返回为true的异常
class NotSuccessException implements Exception {
  late String message;

  NotSuccessException.fromRespData(BaseResponseData respData) {
    message = respData.data;
  }

  @override
  String toString() {
    return 'NotExpectedException{respData: $message}';
  }
}

/// 用于未登录等权限不够,需要跳转授权页面
class UnAuthorizedException implements Exception {
  const UnAuthorizedException();

  @override
  String toString() => 'UnAuthorizedException';
}
