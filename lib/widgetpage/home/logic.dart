import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:huobi_flutter/config/router_manager.dart';
import 'package:huobi_flutter/models/market_tickers.dart';
import 'package:huobi_flutter/provider_model/symbols.dart';
import 'package:get/get.dart';
import 'state.dart';
import 'package:huobi_flutter/config/event_bus.dart';

// 必须是顶层函数
List indexTopCompute(List inData) {
  List<market_tickers> indexTopChange = []; //涨幅榜
  Map<String, Map> newTickersVal = {}; // 成交额榜
  List<market_tickers> indexTopNewCoin = []; // 新币榜

  inData[0].forEach((element) {
    if (element.close == 0.0) {
      return;
    }
    double change = (element.close - element.open) / element.open * 100;
    double value = (element.close / 4 + element.open / 4 + element.high / 4 + element.low / 4) * element.amount;
    element.change = change;
    element.value = value;

    if (element.symbol.substring(element.symbol.length - 4) == 'usdt') {
      element.baseCurrency = element.symbol.substring(0, element.symbol.length - 4);
      element.quoteCurrency = 'usdt';
      indexTopChange.add(element);
    }

    // 新币
    inData[1].forEach((item) {
      var newCoinSymbol = item.toLowerCase() + 'usdt';
      if (newCoinSymbol == element.symbol) {
        if(indexTopNewCoin.length < 10){
          indexTopNewCoin.add(element);
        }
      }
    });

    // 根据币种过滤
    inData[2].forEach((item) {
      if (element.symbol.endsWith(item)) {
        var market = element.symbol.substring(0, element.symbol.length - item.length);
        if (newTickersVal.containsKey(market)) {
          if (newTickersVal[market]!['usdprice'] == '') {
            newTickersVal[market]!['usdprice'] = item == 'usdt' ? element.close : '';
          }
          newTickersVal[market]!['totalVal'] = element.value + newTickersVal[market]!['totalVal'];
        } else {
          newTickersVal[market] = {
            "symbol": market.toUpperCase(),
            "usdprice": item == 'usdt' ? element.close : '',
            "totalVal": element.value,
          };
        }
      }
    });
  });

  List indexTopValue = newTickersVal.values.toList();
  // 成交额排序
  indexTopValue.sort((left, right) => right['totalVal'].round().compareTo(left['totalVal'].round()));

  indexTopValue = indexTopValue.length > 10 ? indexTopValue.sublist(0, 10) : indexTopValue;

  // 涨幅排序
  indexTopChange.sort((left, right) => right.change.round().compareTo(left.change.round()));

  indexTopChange = indexTopChange.length > 10 ? indexTopChange.sublist(0, 10) : indexTopChange;

  return [indexTopChange, indexTopValue, indexTopNewCoin];
}

class HomeLogic extends GetxController {
  final HomeState state = HomeState();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    _listen();
    IndexSelectedHandle();
    IndexTopHandle();
  }

  void _listen() {
    eventBus.on<TickersEvent>().listen((event) {
      IndexSelectedHandle();
      IndexTopHandle();
    });
  }

  void onOpenCustomerService() {}

  bool handleScrollNotification(ScrollNotification notification) {
    final ScrollMetrics metrics = notification.metrics;
    state.alignmentPopularX = -1 + (metrics.pixels / metrics.maxScrollExtent) * 2;
    if (state.alignmentPopularX < -1) {
      state.alignmentPopularX = -1;
    }
    if (state.alignmentPopularX > 1) {
      state.alignmentPopularX = 1;
    }
    update(['indexSelectedTicker']);
    return true;
  }

  void IndexSelectedHandle() {
    state.indexSelected.forEach((selected) {
      var symbol = selected.split('/').map((e) => e.toLowerCase()).join('');
      symbolLogic.tickers.forEach((element) {
        if (element.symbol == symbol) {
          state.indexSelectedTicker[selected] = element;
        }
      });
    });
    update(['indexSelectedTicker']);
  }

  void ChangeTabIndex(index){
    state.tabControllerIndex = index;
    update(['indexTabbarView']);
  }

  void IndexTopHandle() async{
    List result = await compute(indexTopCompute, [symbolLogic.tickers, state.newCoins, symbolLogic.quoteCurrency]) as List;
    state.indexTopChange = result[0];
    state.indexTopValue = result[1];
    state.indexTopNewCoin = result[2];
    update(['indexTabbarView']);
  }

  void toDetail(String market){
    Get.toNamed(RouteConfig.hqDetail, arguments: market);
  }
}
