import 'package:flutter/material.dart';
import 'package:flutter_k_chart/flutter_k_chart.dart';
import 'package:flutter_k_chart/k_chart_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:huobi_flutter/constants/color_constants.dart';
import 'package:huobi_flutter/generated/l10n.dart';
import 'package:huobi_flutter/manager/device_manager.dart';
import 'package:huobi_flutter/models/kline.dart';
import 'package:huobi_flutter/service/huobi_repository.dart';
import 'package:huobi_flutter/utils/ImageUtil.dart';

class MyKChartWidget extends StatefulWidget {
  final String market;
  final int prec;

  const MyKChartWidget(String this.market, this.prec, {Key? key}) : super(key: key);

  @override
  _MyKChartWidgetState createState() => _MyKChartWidgetState();
}

class _MyKChartWidgetState extends State<MyKChartWidget> with TickerProviderStateMixin {
  List<KLineEntity> datas = [];
  bool showLoading = true;
  MainState _mainState = MainState.MA;
  SecondaryState _secondaryState = SecondaryState.NONE;
  bool isLine = false;
  List<DepthEntity> _bids = [], _asks = [];

  late List bars;
  late List moreBars;
  int moreBarsIndex = -1;

  late TabController _tabController;

  GlobalKey _tapSettingsWidget = GlobalKey();

  bool isSettingChecked = false;
  bool isTimeMoreChecked = false;
  bool MoreWidgetAnimation = false;

  int SelectedIndex = 1;

  OverlayEntry? settingsOverlay;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getKline();
    _tabController = TabController(length: 7, initialIndex: 1, vsync: this)
      ..addListener(() {
        // 点击更多不滚动
        if (_tabController.index == 5 && moreBarsIndex == -1) {
          _tabController.index = SelectedIndex;
        }
      });
  }

  Future<void> getKline({String period = '60min'}) async {
    setState(() {
      showLoading = true;
    });
    datas.clear();
    List<Kline> result = await HuobiRepository.fetchkline({"period": period, "size": 200, "symbol": widget.market});
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
      datas.add(KLineEntity.fromJson(lineData));
    });
    DataUtil.calculate(datas);
    setState(() {
      showLoading = false;
    });
  }

  void ChangeTab(index) {
    if (SelectedIndex != index && index != 5) {
      SelectedIndex = index;
      moreBarsIndex = -1;
      isLine = false;
      switch (index) {
        case 0:
          getKline(period: '15min');
          break;
        case 1:
          getKline(period: '60min');
          break;
        case 2:
          getKline(period: '4hour');
          break;
        case 3:
          getKline(period: '1day');
          break;
        case 4:
          getKline(period: '1week');
          break;
      }
    } else {
      setState(() {
        isTimeMoreChecked = !isTimeMoreChecked;
        _showOverlay(isTimeMoreChecked);
      });
    }
  }

  void MoreChangeTab(index) {
    if (moreBarsIndex != index) {
      SelectedIndex = 5;
      moreBarsIndex = index;
      _tabController.index = SelectedIndex;
      switch (index) {
        case 0:
          isLine = true;
          getKline(period: '1min');
          break;
        case 1:
          isLine = false;
          getKline(period: '1min');
          break;
        case 2:
          isLine = false;
          getKline(period: '5min');
          break;
        case 3:
          isLine = false;
          getKline(period: '30min');
          break;
        case 4:
          isLine = false;
          getKline(period: '1day');
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bars = [
      '15' + S.of(context).chartTab2,
      '1' + S.of(context).chartTab3,
      '4' + S.of(context).chartTab3,
      '1' + S.of(context).chartTab4,
      '1' + S.of(context).chartTab5,
      S.of(context).chartTabMore,
      S.of(context).chartTab7,
    ];

    moreBars = [
      S.of(context).chartTab1,
      '1' + S.of(context).chartTab2,
      '5' + S.of(context).chartTab2,
      '30' + S.of(context).chartTab2,
      '1' + S.of(context).chartTab6,
    ];

    return WillPopScope(
      onWillPop: () {
        settingsOverlay?.remove();
        return Future.value(true);
      },
      child: Column(
        children: [
          _chartBarWidget(),
          _chartWidget(),
        ],
      ),
    );
  }

  Widget _chartBarWidget() {
    return Container(
      key: _tapSettingsWidget,
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
                        controller: _tabController,
                        unselectedLabelColor: defaultColor,
                        indicatorSize: TabBarIndicatorSize.label,
                        indicatorColor: kTextColorKChartTab,
                        labelColor: kTextColorKChartTab,
                        labelStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                        labelPadding: EdgeInsets.zero,
                        onTap: ChangeTab,
                        tabs: List.generate(
                          bars.length,
                          (index) => Tab(
                            child: Text((index == bars.length - 2 && moreBarsIndex >= 0) ? moreBars[moreBarsIndex] : bars[index]),
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
                            colorBlendMode: isTimeMoreChecked ? BlendMode.srcIn : BlendMode.dst,
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
                  setState(() {
                    isSettingChecked = !isSettingChecked;
                  });
                },
                child: Container(
                  width: 50,
                  child: ImageUtil.getAssetsImage(
                    "kline_index_setting_icon",
                    height: 16,
                    fit: BoxFit.fitHeight,
                    color: kPrimaryColor,
                    colorBlendMode: isSettingChecked ? BlendMode.srcIn : BlendMode.dst,
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
      child: showLoading
          ? _loadingWidget()
          : KChartWidget(
              datas,
              isLine: isLine,
              mainState: _mainState,
              secondaryState: _secondaryState,
              volState: VolState.VOL,
              fractionDigits: widget.prec,
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
      settingsOverlay = _createSelectViewWithContext(_tapSettingsWidget);
      Overlay.of(context)!.insert(settingsOverlay!);
      Future.delayed(Duration(milliseconds: 10), () {
        setState(() {
          MoreWidgetAnimation = true;
          settingsOverlay!.markNeedsBuild();
        });
      });
    } else {
      setState(() {
        MoreWidgetAnimation = false;
        settingsOverlay!.markNeedsBuild();
      });
      settingsOverlay?.remove();
    }
  }

  OverlayEntry _createSelectViewWithContext(GlobalKey tapWidget) {
    //屏幕参数
    var screenSize = DeviceManager.getInstance();

    var tapWidgetRx = tapWidget.currentContext!.findRenderObject() as RenderBox;
    Size? parentSize = tapWidgetRx.size;
    var parentPosition = tapWidgetRx.localToGlobal(Offset.zero);

    return OverlayEntry(builder: (BuildContext context) {
      return Positioned(
        top: parentPosition.dy + parentSize.height,
        width: screenSize.screenWidth,
        height: screenSize.screenHeight - parentPosition.dy - parentSize.height,
        child: Stack(
          children: [
            AnimatedOpacity(
              duration: Duration(milliseconds: 200),
              opacity: MoreWidgetAnimation ? 1 : 0,
              curve: Curves.linear,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    isTimeMoreChecked = false;
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
            AnimatedPositioned(
              top: MoreWidgetAnimation ? 0.0 : -50,
              child: Container(
                width: screenSize.screenWidth,
                height: 50,
                decoration: BoxDecoration(
                  color: Color(0xfffefefe),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(moreBars.length, (index) {
                    return GestureDetector(
                      onTap: () {
                        isTimeMoreChecked = false;
                        _showOverlay(false);
                        MoreChangeTab(index);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                        decoration: BoxDecoration(
                          color: Color(0xfff6f6f8),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: Text(
                          "${moreBars[index]}",
                          style: TextStyle(
                            color: defaultColor,
                            fontSize: 11,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              curve: Curves.ease,
              duration: Duration(milliseconds: 300),
            ),
          ],
        ),
      );
    });
  }
}
