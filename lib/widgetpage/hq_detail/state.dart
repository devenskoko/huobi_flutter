import 'package:flutter/material.dart';
import 'package:flutter_k_chart/entity/depth_entity.dart';
import 'package:huobi_flutter/models/market_trade.dart';

class HqDetailState {
  late String market;
  Map marketData = {};
  int prec = 0;
  late TabController tabController;
  List<DepthEntity> bids = [], asks = [];
  double bidsAmountTotal = 0;
  double asksAmountTotal = 0;
  int tabControllerIndex = 0;

  List<market_trade> historyOrder = [];

  HqDetailState() {}
}
