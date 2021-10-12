import 'package:flutter/foundation.dart';
import 'package:localstorage/localstorage.dart';
import 'package:huobi_flutter/models/common_symbols.dart';
import 'package:huobi_flutter/models/market_tickers.dart';
import 'package:huobi_flutter/service/huobi_repository.dart';
import 'package:huobi_flutter/config/event_bus.dart';

const String commonSymbols = 'common_symbols';
const String marketTickers = 'market_tickers';
const String hQuoteCurrency = 'quote_currency';

// 必须是顶层函数
List tickersCompute(List inData) {
  var result = inData[1];
  inData[0].forEach((key, value) {
    for (var i = 0; i < result.length; i++) {
      if (result[i].symbol == key) {
        result[i] = value;
      }
    }
  });
  return result;
}

class symbolLogic {
  static late LocalStorage localStorage;
  static int localStorageNum = 0;

  static List<common_symbols> _symbols = [];
  static List<market_tickers> _tickers = [];
  static Map<String, market_tickers> _oldtickers = Map();
  static List<String> _quoteCurrency = [];

  static List<common_symbols> get symbols => _symbols;

  static List<market_tickers> get tickers => _tickers;

  static List<String> get quoteCurrency => _quoteCurrency;

  static bool mounted = true;

  symbolLogic() {
    initStorage();
    initFuture();
    // socketLogic.initSocket();
  }

  static void initStorage() async {
    localStorage = LocalStorage('symbols');
    await localStorage.ready;
    List<common_symbols> localList = (localStorage.getItem(commonSymbols) ?? []).map<common_symbols>((item) {
      return common_symbols.fromJson(item);
    }).toList();
    _symbols = localList;

    List<market_tickers> localList2 = (localStorage.getItem(marketTickers) ?? []).map<market_tickers>((item) {
      return market_tickers.fromJson(item);
    }).toList();
    _tickers = localList2;

    List<String> localList3 = (localStorage.getItem(hQuoteCurrency) ?? []).map<String>((item) {
      return item as String;
    }).toList();
    _quoteCurrency = localList3;
  }

  static Future initFuture() async {
    List<Future> futures = [];
    futures.add(HuobiRepository.fetchCommonSymbols());
    futures.add(HuobiRepository.fetchMarketTickers());
    return await Future.wait(futures).then((result) {
      UpdateSymbols(result[0]);
      UpdateTickers(result[1]);
    });
  }

  static void UpdateSymbols(result) async {
    List<common_symbols> netList = result;
    if (netList.isNotEmpty) {
      _symbols = netList;

      _quoteCurrency.clear();
      _symbols.forEach((element) {
        if (!_quoteCurrency.contains(element.quoteCurrency) && element.quoteCurrency != '') {
          _quoteCurrency.add(element.quoteCurrency ?? '');
        }
      });

      await localStorage.ready;
      await localStorage.setItem(commonSymbols, netList);
      await localStorage.setItem(hQuoteCurrency, _quoteCurrency);
    }
  }

  static void UpdateTickers(result) async {
    List<market_tickers> netList = result;
    if (netList.isNotEmpty) {
      _tickers = netList;
      eventBus.fire(new TickersEvent(_tickers));

      await localStorage.ready;
      await localStorage.setItem(marketTickers, _tickers);
    }
  }

  static void SingleUpdateTicker(data) async {
    var newSymbol = data['ch'].split('.')[1];
    data['tick']['symbol'] = newSymbol;
    market_tickers ticker = market_tickers.fromJson(data['tick']);
    _oldtickers[newSymbol] = ticker;
    if (!mounted) {
      return;
    }
    mounted = false;
    await Future.delayed(Duration(milliseconds: 400));
    List<market_tickers> result = await compute(tickersCompute, [_oldtickers, _tickers]) as List<market_tickers>;
    _tickers = result;
    eventBus.fire(new TickersEvent(_tickers));
    localStorageNum++;
    if (localStorageNum > 10) {
      localStorageNum = 0;
      localStorage.setItem(marketTickers, _tickers);
    }
    mounted = true;
  }
}
