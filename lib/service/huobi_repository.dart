// 获取所有交易对
import 'package:huobi_flutter/config/net/my_api.dart';
import 'package:huobi_flutter/models/common_symbols.dart';
import 'package:huobi_flutter/models/depth.dart';
import 'package:huobi_flutter/models/kline.dart';
import 'package:huobi_flutter/models/market_tickers.dart';
import 'package:huobi_flutter/models/market_trade.dart';

class HuobiRepository {
  // 获取所有交易对
  static Future fetchCommonSymbols() async {
    var response = await http.get('/v1/common/symbols');
    return response.data.map<common_symbols>((item) => common_symbols.fromJson(item)).toList();
  }

  // 所有交易对的最新 Tickers
  static Future fetchMarketTickers() async {
    var response = await http.get('/market/tickers');
    return response.data.map<market_tickers>((item) => market_tickers.fromJson(item)).toList();
  }

  // 获取k线数据
  static Future fetchkline(params) async {
    var response = await http.get('/market/history/kline', queryParameters: params);
    return response.data.map<Kline>((item) => Kline.fromJson(item)).toList().reversed.toList();
  }

  // 获取深度数据
  static Future fetchDepth(params) async {
    var response = await http.get('/market/depth', queryParameters: params);
    return Depth.fromJson(response.data);
  }

  // 成交记录
  static Future fetchMarketTrade(params) async {
    var response = await http.get('/market/history/trade', queryParameters: params);
    List result = [];
    response.data.forEach((item){
      result.addAll(item['data']);
    });
    return result.map<market_trade>((item) => market_trade.fromJson(item)).toList();
  }
}
