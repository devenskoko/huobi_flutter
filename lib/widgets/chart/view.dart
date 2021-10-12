import 'package:flutter/material.dart';
import 'package:flutter_k_chart/depth_chart.dart';
import 'package:flutter_k_chart/k_chart_widget.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:huobi_flutter/constants/color_constants.dart';
import 'package:huobi_flutter/generated/l10n.dart';
import 'package:huobi_flutter/manager/device_manager.dart';
import 'package:huobi_flutter/utils/ImageUtil.dart';

import 'logic.dart';

class ChartWidget extends StatefulWidget {
  final String market;
  final int prec;

  const ChartWidget(String this.market, int this.prec, {Key? key}) : super(key: key);

  @override
  _ChartWidgetState createState() => _ChartWidgetState();
}

class _ChartWidgetState extends State<ChartWidget> with TickerProviderStateMixin {
  final logic = Get.put(ChartLogic());
  final state = Get.put(ChartLogic()).state;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    logic.argumentsData(widget.market, widget.prec);
    state.tabController = TabController(length: 7, initialIndex: 1, vsync: this)
      ..addListener(() {
        // 点击更多不滚动
        if (state.tabController.index == 5 && state.moreBarsIndex == -1) {
          state.tabController.index = state.selectedIndex;
        }
      });
  }

  void ChangeTab(index) {
    if (state.selectedIndex != index && index != 5) {
      logic.changeSelectedIndex(index);
      logic.changeMoreBarsIndex(-1);
      logic.changeChartType(false);
      if (state.moreWidgetAnimation) {
        logic.changeWidgetAnimation(false);
        logic.updateOverlay();
        logic.changeTimeMoreChecked(false);
        Future.delayed(Duration(milliseconds: 200), () {
          logic.removeOverlay();
        });
      }
      switch (index) {
        case 0:
          logic.getKline(period: '15min');
          break;
        case 1:
          logic.getKline(period: '60min');
          break;
        case 2:
          logic.getKline(period: '4hour');
          break;
        case 3:
          logic.getKline(period: '1day');
          break;
        case 4:
          logic.getKline(period: '1week');
          break;
        case 6:
          logic.getDepth();
          break;
      }
    } else {
      logic.changeTimeMoreChecked(!state.isTimeMoreChecked);
      _showOverlay(state.isTimeMoreChecked);
    }
  }

  void MoreChangeTab(index) {
    if (state.moreBarsIndex != index) {
      logic.changeSelectedIndex(5);
      logic.changeMoreBarsIndex(index);
      logic.changeTabController(state.selectedIndex);
      switch (index) {
        case 0:
          logic.changeChartType(true);
          logic.getKline(period: '1min');
          break;
        case 1:
          logic.changeChartType(false);
          logic.getKline(period: '1min');
          break;
        case 2:
          logic.changeChartType(false);
          logic.getKline(period: '5min');
          break;
        case 3:
          logic.changeChartType(false);
          logic.getKline(period: '30min');
          break;
        case 4:
          logic.changeChartType(false);
          logic.getKline(period: '1day');
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    state.bars = [
      '15' + S.of(context).chartTab2,
      '1' + S.of(context).chartTab3,
      '4' + S.of(context).chartTab3,
      '1' + S.of(context).chartTab4,
      '1' + S.of(context).chartTab5,
      S.of(context).chartTabMore,
      S.of(context).chartTab7,
    ];

    state.moreBars = [
      S.of(context).chartTab1,
      '1' + S.of(context).chartTab2,
      '5' + S.of(context).chartTab2,
      '30' + S.of(context).chartTab2,
      '1' + S.of(context).chartTab6,
    ];

    return GetBuilder<ChartLogic>(
      builder: (logic) {
        return WillPopScope(
          onWillPop: () {
            if (state.moreWidgetAnimation || state.settingCheckedAnimation) {
              logic.removeOverlay();
            }
            return Future.value(true);
          },
          child: Column(
            children: [
              _chartBarWidget(),
              _chartWidget(),
            ],
          ),
        );
      },
    );
  }

  Widget _chartBarWidget() {
    return Container(
      key: state.tapSettingsWidget,
      width: double.infinity,
      height: 30,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1, color: kDividerColor),
        ),
      ),
      child: Stack(
        children: [
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Stack(
                  children: [
                    Theme(
                      data: ThemeData(
                        //去掉水波纹
                        highlightColor: Color.fromRGBO(0, 0, 0, 0),
                        splashColor: Color.fromRGBO(0, 0, 0, 0),
                      ),
                      child: TabBar(
                        controller: state.tabController,
                        unselectedLabelColor: defaultColor,
                        indicatorSize: TabBarIndicatorSize.label,
                        indicatorColor: kTextColorKChartTab,
                        labelColor: kTextColorKChartTab,
                        labelStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                        labelPadding: EdgeInsets.zero,
                        onTap: ChangeTab,
                        tabs: List.generate(
                          state.bars.length,
                          (index) => Tab(
                            child: Text((index == state.bars.length - 2 && state.moreBarsIndex >= 0) ? state.moreBars[state.moreBarsIndex] : state.bars[index]),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 50,
                      bottom: 9,
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                          width: 40,
                          padding: EdgeInsets.fromLTRB(25, 15, 0, 0),
                          child: ImageUtil.getAssetsImage(
                            "market_info_index_collpsed",
                            height: 5,
                            fit: BoxFit.fitHeight,
                            color: Colors.black,
                            colorBlendMode: state.isTimeMoreChecked ? BlendMode.srcIn : BlendMode.dst,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 10,
                width: 0.5,
                color: kTextGrayBlueColor,
              ),
              GestureDetector(
                onTap: () {
                  logic.changeSettingChecked(!state.isSettingChecked);
                  _showOverlay(state.isSettingChecked);
                },
                child: Container(
                  width: 50,
                  child: ImageUtil.getAssetsImage(
                    "kline_index_setting_icon",
                    height: 16,
                    fit: BoxFit.fitHeight,
                    color: kPrimaryColor,
                    colorBlendMode: state.isSettingChecked ? BlendMode.srcIn : BlendMode.dst,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _chartWidget() {
    return Container(
      width: double.infinity,
      height: 500,
      alignment: Alignment.center,
      child: state.showLoading
          ? _loadingWidget()
          : state.depthShow
              ? Container(
                  height: 500,
                  width: double.infinity,
                  child: DepthChart(state.bids, state.asks),
                )
              : KChartWidget(
                  state.datas,
                  isLine: state.isLine,
                  mainState: state.mainState,
                  secondaryState: state.secondaryState,
                  volState: VolState.VOL,
                  fractionDigits: state.prec,
                ),
    );
  }

  Widget _loadingWidget() {
    return Container(
      width: double.infinity,
      height: 450,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/lottie/refresh_header.json',
            height: 35,
          ),
        ],
      ),
    );
  }

  //现实显示具体方法 在需要的地方掉用即可
  _showOverlay(bool isShow) {
    if (isShow) {
      logic.updateOverlay();
      logic.removeOverlay();
      logic.setOverlay(_createSelectViewWithContext(state.tapSettingsWidget));
      Overlay.of(context)!.insert(state.settingsOverlay!);
      Future.delayed(Duration(milliseconds: 20), () {
        logic.changeWidgetAnimation(true);
        logic.updateOverlay();
      });
    } else {
      logic.changeWidgetAnimation(false);
      logic.updateOverlay();
      Future.delayed(Duration(milliseconds: 200), () {
        logic.removeOverlay();
      });
    }
  }

  OverlayEntry _createSelectViewWithContext(GlobalKey tapWidget) {
    //屏幕参数
    var screenSize = DeviceManager.getInstance();

    var tapWidgetRx = tapWidget.currentContext!.findRenderObject() as RenderBox;
    Size? parentSize = tapWidgetRx.size;
    var parentPosition = tapWidgetRx.localToGlobal(Offset.zero);
    var widgetAnimation = state.isSettingChecked || state.isTimeMoreChecked;
    return OverlayEntry(builder: (BuildContext context) {
      return Positioned(
        top: parentPosition.dy + parentSize.height,
        width: screenSize.screenWidth,
        height: screenSize.screenHeight - parentPosition.dy - parentSize.height,
        child: Stack(
          children: [
            AnimatedOpacity(
              duration: Duration(milliseconds: 200),
              opacity: widgetAnimation ? 1 : 0,
              curve: Curves.linear,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    logic.changeTimeMoreChecked(false);
                    _showOverlay(false);
                  });
                },
                child: Container(
                  height: screenSize.screenHeight - parentPosition.dy - parentSize.height,
                  width: double.infinity,
                  color: Colors.black54,
                ),
              ),
            ),
            // 更多
            state.isTimeMoreChecked
                ? AnimatedPositioned(
                    top: state.moreWidgetAnimation ? 0.0 : -50,
                    child: Container(
                      width: screenSize.screenWidth,
                      height: 60,
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Color(0xfffefefe),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(state.moreBars.length, (index) {
                          return GestureDetector(
                            onTap: () {
                              state.isTimeMoreChecked = false;
                              _showOverlay(false);
                              MoreChangeTab(index);
                            },
                            child: Container(
                              width: 60,
                              height: 30,
                              margin: EdgeInsets.only(right: index != (state.moreBars.length - 1) ? 10 : 0),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: state.moreBarsIndex == index ? Colors.white : Color(0xfff6f6f8),
                                borderRadius: BorderRadius.all(Radius.circular(5)),
                                border: state.moreBarsIndex == index ? Border.all(width: 1, color: kTextColorKChartTab) : null,
                              ),
                              child: Text(
                                "${state.moreBars[index]}",
                                style: TextStyle(
                                  color: state.moreBarsIndex == index ? kTextColorKChartTab : defaultColor,
                                  fontSize: 12,
                                  decoration: TextDecoration.none,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    curve: Curves.ease,
                    duration: Duration(milliseconds: 300),
                  )
                : SizedBox.shrink(),
            // 图形
            state.isSettingChecked
                ? AnimatedPositioned(
                    top: state.settingCheckedAnimation ? 0.0 : -160,
                    curve: Curves.ease,
                    duration: Duration(milliseconds: 300),
                    child: Container(
                      width: screenSize.screenWidth,
                      height: 160,
                      decoration: BoxDecoration(
                        color: Color(0xfffefefe),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                      ),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              S.of(context).mainChart,
                              style: TextStyle(
                                color: kTextColor,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.none,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: List.generate(state.mainChartTabs.length, (index) {
                                return GestureDetector(
                                  onTap: () {
                                    if (state.mainChartTabsIndex != index) {
                                      state.mainChartTabsIndex = index;
                                    } else {
                                      state.mainChartTabsIndex = -1;
                                    }
                                    switch(state.mainChartTabsIndex){
                                      case -1:
                                        logic.changeMainState(MainState.NONE);
                                        break;
                                      case 0:
                                        logic.changeMainState(MainState.MA);
                                        break;
                                      case 1:
                                        logic.changeMainState(MainState.BOLL);
                                    }
                                    logic.updateOverlay();
                                  },
                                  child: Container(
                                    width: 82,
                                    height: 30,
                                    margin: EdgeInsets.only(right: index != (state.mainChartTabs.length - 1) ? 10 : 0),
                                    decoration: BoxDecoration(
                                      color: state.mainChartTabsIndex == index ? Colors.white : Color(0xfff6f6f8),
                                      borderRadius: BorderRadius.all(Radius.circular(5)),
                                      border: state.mainChartTabsIndex == index ? Border.all(width: 1, color: kTextColorKChartTab) : null,
                                    ),
                                    alignment: Alignment.center,
                                    child: Padding(
                                      padding: EdgeInsets.only(top: 2),
                                      child: Text(
                                        "${state.mainChartTabs[index]}",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: state.mainChartTabsIndex == index ? kTextColorKChartTab : defaultColor,
                                          fontSize: 12,
                                          decoration: TextDecoration.none,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              S.of(context).subChart,
                              style: TextStyle(
                                color: kTextColor,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.none,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: List.generate(state.subChartTabs.length, (index) {
                                return GestureDetector(
                                  onTap: () {
                                    if (state.subChartTabsIndex != index) {
                                      state.subChartTabsIndex = index;
                                    } else {
                                      state.subChartTabsIndex = -1;
                                    }
                                    switch(state.subChartTabsIndex){
                                      case -1:
                                        logic.changeSecondaryState(SecondaryState.NONE);
                                        break;
                                      case 0:
                                        logic.changeSecondaryState(SecondaryState.MACD);
                                        break;
                                      case 1:
                                        logic.changeSecondaryState(SecondaryState.KDJ);
                                        break;
                                      case 2:
                                        logic.changeSecondaryState(SecondaryState.RSI);
                                        break;
                                      case 3:
                                        logic.changeSecondaryState(SecondaryState.WR);
                                    }
                                    logic.updateOverlay();
                                  },
                                  child: Container(
                                    width: 82,
                                    height: 30,
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.only(right: index != (state.subChartTabs.length - 1) ? 10 : 0),
                                    decoration: BoxDecoration(
                                      color: state.subChartTabsIndex == index ? Colors.white : Color(0xfff6f6f8),
                                      borderRadius: BorderRadius.all(Radius.circular(5)),
                                      border: state.subChartTabsIndex == index ? Border.all(width: 1, color: kTextColorKChartTab) : null,
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.only(top: 2),
                                      child: Text(
                                        "${state.subChartTabs[index]}",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: state.subChartTabsIndex == index ? kTextColorKChartTab : defaultColor,
                                          fontSize: 12,
                                          decoration: TextDecoration.none,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : SizedBox.shrink(),
          ],
        ),
      );
    });
  }
}
