import 'dart:math';

import 'package:flutter_k_chart/entity/depth_entity.dart';
import 'package:get/get.dart';
import 'package:huobi_flutter/config/event_bus.dart';
import 'package:huobi_flutter/provider_model/socket_client.dart';
import 'package:huobi_flutter/models/depth.dart';
import 'package:huobi_flutter/service/huobi_repository.dart';

import 'state.dart';
import 'package:huobi_flutter/provider_model/symbols.dart';

class HqDetailLogic extends GetxController {
  final HqDetailState state = HqDetailState();

  final subId = "depth${new Random()}";

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    _listen();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    state.tabController.addListener(() {
      state.tabControllerIndex = state.tabController.index;
    });
  }

  void _listen() {
    eventBus.on<SocketEvent>().listen((event) {
      updateDepth(event.socketmsg);
    });
  }

  void updateMarket(String market) {
    state.market = market;
    initData();

    // 订阅 深度
    String str = '{"sub": "market.${state.market}.depth.step0"},"id": "${subId}"';
    print('深度订阅');
    socketLogic.sub(str);
  }

  unsubscribe() {
    // 取消订阅
    String str = '{"unsub": "market.${state.market}.depth.step0","id": "${subId}"}';
    print('深度取消订阅');
    socketLogic.unsub(str);
  }

  void updateDepth(data) {
    Depth tick = Depth.fromJson(data["tick"]);
    state.asksAmountTotal = 0.0;
    state.bidsAmountTotal = 0.0;
    int num = 0;
    var bids = tick.bids!.map((item) => DepthEntity(item[0], item[1])).toList().cast<DepthEntity>();
    var asks = tick.asks!.map((item) => DepthEntity(item[0], item[1])).toList().cast<DepthEntity>();
    state.asks = asks;
    state.bids = bids;
    asks.forEach((item) {
      num++;
      if (num <= 20) {
        state.asksAmountTotal += item.amount;
      }
    });
    num = 0;
    bids.forEach((item) {
      num++;
      if (num <= 20) {
        state.bidsAmountTotal += item.amount;
      }
    });
    update(['orderBook']);
  }

  void initData() {
    int num = 0;
    double usdthusdPrice = 0.0;
    for (final item in symbolLogic.tickers) {
      if (item.symbol == state.market) {
        state.marketData = item.toJson();
        var price = item.close;
        state.prec = price.toString().split('.')[1].length;
        num++;
      }
      if (item.symbol == 'usdthusd') {
        usdthusdPrice = item.close;
        num++;
      }
      if (num >= 2) {
        state.marketData['usdprice'] = usdthusdPrice;
        break;
      }
    }
    update(['detailTop']);
  }

  Future<void> getDepth() async {
    state.asksAmountTotal = 0.0;
    state.bidsAmountTotal = 0.0;
    Depth tick = await HuobiRepository.fetchDepth({"depth": 20, "symbol": state.market, "type": "step0"});
    var bids = tick.bids!.map((item) => DepthEntity(item[0], item[1])).toList().cast<DepthEntity>();
    var asks = tick.asks!.map((item) => DepthEntity(item[0], item[1])).toList().cast<DepthEntity>();
    state.asks = asks;
    state.bids = bids;
    asks.forEach((item) {
      state.asksAmountTotal += item.amount;
    });
    bids.forEach((item) {
      state.bidsAmountTotal += item.amount;
    });
    update(['orderBook']);
  }

  String numFormat(double num) {
    String dealString;
    if (num >= 100000000) {
      dealString = "${(num / 100000000).toStringAsFixed(2)}亿";
    } else if (num >= 10000000) {
      dealString = "${(num / 10000000).toStringAsFixed(2)}千万";
    } else if (num >= 1000000) {
      dealString = "${(num / 1000000).toStringAsFixed(2)}百万";
    } else if (num >= 10000) {
      dealString = "${(num / 10000).toStringAsFixed(2)}万";
    } else {
      dealString = num.toStringAsFixed(2);
    }
    return dealString;
  }
}
