import 'package:flutter/material.dart';
import 'package:flutter_k_chart/flutter_k_chart.dart';
import 'package:flutter_k_chart/k_chart_widget.dart';

class ChartState {
  List<KLineEntity> datas = [];
  bool showLoading = true;
  late MainState mainState;
  late SecondaryState secondaryState;
  bool isLine = false;
  List<DepthEntity> bids = [], asks = [];
  bool volHidden = false;
  bool depthShow = false;

  late List bars; // 周期切换tab
  late List moreBars; // 更多tab
  late List mainChartTabs; // 主图
  int mainChartTabsIndex = 0;
  late List subChartTabs; // 副图
  int subChartTabsIndex = -1;
  int moreBarsIndex = -1; // 选中的更多tab

  late TabController tabController;

  GlobalKey tapSettingsWidget = GlobalKey();

  bool isSettingChecked = false;
  bool isTimeMoreChecked = false;
  bool moreWidgetAnimation = false; // 更多动画控制
  bool settingCheckedAnimation = false; // 指标动画控制

  int selectedIndex = 1;

  OverlayEntry? settingsOverlay;

  late String market;

  late int prec;

  ChartState() {
    mainState = MainState.MA;
    secondaryState = SecondaryState.NONE;
    mainChartTabs = ["MA", "BOLL"];
    subChartTabs = ["MACD", "KDJ", "RSI", "WR"];
  }
}
