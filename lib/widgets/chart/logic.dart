import 'dart:math';

import 'package:get/get.dart';
import 'package:huobi_flutter/config/event_bus.dart';
import 'package:huobi_flutter/models/depth.dart';
import 'package:huobi_flutter/models/kline.dart';
import 'package:huobi_flutter/service/huobi_repository.dart';
import 'package:flutter_k_chart/flutter_k_chart.dart';
import 'state.dart';
import 'package:huobi_flutter/provider_model/socket_client.dart';

class ChartLogic extends GetxController {
  final ChartState state = ChartState();
  final subId = "depth${new Random()}";
  late String lastSub = '';

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    _listen();
  }

  void _listen() {
    eventBus.on<SocketEvent>().listen((event) {
      updateDepth(event.socketmsg);
    });
    eventBus.on<KLineEvent>().listen((event) {
      if (state.datas.isEmpty) {
        return;
      }
      KLineEntity result = KLineEntity.fromJson(event.klinemsg["tick"]);
      if (result.id == state.datas.last.id) {
        state.datas.last = result;
        DataUtil.updateLastData(state.datas);
      } else {
        DataUtil.addLastData(state.datas, result);
      }
    });
  }

  argumentsData(String market, int prec) {
    state.market = market;
    state.prec = prec;
    getKline();
  }

  Future<void> getKline({String period = '60min'}) async {
    if (lastSub != '') {
      socketLogic.unsub(lastSub);
    }
    state.showLoading = true;
    state.datas.clear();
    update();
    List<Kline> result = await HuobiRepository.fetchkline({"period": period, "size": 200, "symbol": state.market});
    result.forEach((item) {
      Map<String, dynamic> lineData = {
        "open": item.open,
        "high": item.high,
        "low": item.low,
        "close": item.close,
        "vol": item.vol,
        "amount": item.amount,
        "id": item.id,
      };
      state.datas.add(KLineEntity.fromJson(lineData));
    });
    DataUtil.calculate(state.datas);
    state.showLoading = false;
    update();

    // 订阅 k线
    String str = '{"sub": "market.${state.market}.kline.${period}"},"id": "${subId}"';
    lastSub = '{"unsub": "market.${state.market}.kline.${period}"},"id": "${subId}"';
    socketLogic.sub(str);
  }

  updateDepth(data) {
    if (!state.depthShow) {
      return;
    }
    Depth tick = Depth.fromJson(data["tick"]);
    var bids = tick.bids!.map((item) => DepthEntity(item[0], item[1])).toList().cast<DepthEntity>();
    var asks = tick.asks!.map((item) => DepthEntity(item[0], item[1])).toList().cast<DepthEntity>();
    initDepth(bids, asks);
  }

  Future<void> getDepth() async {
    state.showLoading = true;
    state.depthShow = true;
  }

  void initDepth(List<DepthEntity> bids, List<DepthEntity> asks) {
    if (bids == null || asks == null || bids.isEmpty || asks.isEmpty) return;
    state.bids = [];
    state.asks = [];
    double amount = 0.0;
    bids.sort((left, right) => left.price.compareTo(right.price));
    //累加买入委托量
    bids.reversed.forEach((item) {
      amount += item.amount;
      item.amount = amount;
      state.bids.insert(0, item);
    });

    amount = 0.0;
    asks.sort((left, right) => left.price.compareTo(right.price));
    //累加卖出委托量
    asks.forEach((item) {
      amount += item.amount;
      item.amount = amount;
      state.asks.add(item);
    });
    state.depthShow = true;
    state.showLoading = false;
    update();
  }

  changeSelectedIndex(int index) {
    state.selectedIndex = index;
    state.depthShow = false;
  }

  changeMoreBarsIndex(int index) {
    state.moreBarsIndex = index;
    state.depthShow = false;
    update();
  }

  changeChartType(bool isLine) {
    state.isLine = isLine;
    state.depthShow = false;
  }

  changeTimeMoreChecked(bool isTimeMoreChecked) {
    state.isTimeMoreChecked = isTimeMoreChecked;
    if (isTimeMoreChecked) {
      state.isSettingChecked = false;
    }
  }

  changeSettingChecked(bool isSettingChecked) {
    state.isSettingChecked = isSettingChecked;
    if (isSettingChecked) {
      state.isTimeMoreChecked = false;
    }
  }

  changeWidgetAnimation(bool widgetAnimation) {
    if (state.isTimeMoreChecked) {
      state.moreWidgetAnimation = widgetAnimation;
      state.settingCheckedAnimation = false;
    }
    if (state.isSettingChecked) {
      state.settingCheckedAnimation = widgetAnimation;
      state.moreWidgetAnimation = false;
    }

    if (!widgetAnimation) {
      state.moreWidgetAnimation = false;
      state.settingCheckedAnimation = false;
    }
  }

  updateOverlay() {
    if (state.settingsOverlay != null) {
      state.settingsOverlay!.markNeedsBuild();
      update();
    }
  }

  setOverlay(widget) {
    state.settingsOverlay = widget;
    update();
  }

  removeOverlay() {
    if (state.settingsOverlay != null) {
      state.settingsOverlay?.remove();
      state.settingsOverlay = null;
      update();
    }
  }

  changeTabController(index) {
    if (state.tabController.index != index) {
      state.tabController.index = index;
      state.showLoading = true;
      update();
    }
  }

  changeMainState(MainState data) {
    state.mainState = data;
  }

  changeSecondaryState(SecondaryState data) {
    state.secondaryState = data;
  }
}
