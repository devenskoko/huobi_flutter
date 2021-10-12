import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:get/get.dart';
import 'package:huobi_flutter/constants/color_constants.dart';
import 'package:huobi_flutter/manager/device_manager.dart';
import 'package:huobi_flutter/provider_model/symbols.dart';
import 'package:huobi_flutter/utils/ImageUtil.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

import 'package:huobi_flutter/widgetpage/home/logic.dart';
import 'package:huobi_flutter/widgets/LogoHeader.dart';
import 'package:huobi_flutter/widgets/SwiperPagination.dart';
import 'package:huobi_flutter/generated/l10n.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  bool get wantKeepAlive => true; //切换界面不重新绘制
  late EasyRefreshController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = EasyRefreshController();
  }

  @override
  Widget build(BuildContext context) {
    DeviceManager.getInstance().init(context);
    super.build(context);
    final logic = Get.isRegistered<HomeLogic>() ? Get.find<HomeLogic>() : Get.put(HomeLogic());
    final state = Get.isRegistered<HomeLogic>() ? Get.find<HomeLogic>().state : Get.put(HomeLogic().state);

    return GetBuilder<HomeLogic>(builder: (logic) {
      return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80.0),
          child: Container(
            margin: EdgeInsets.only(top: DeviceManager.getInstance().statusBarHeight),
            child: _getTopBarWidget(logic),
          ),
        ),
        backgroundColor: Colors.white,
        body: EasyRefresh(
          child: SingleChildScrollView(
            child: Column(
              children: _getPageContent(state, logic),
            ),
          ),
          enableControlFinishRefresh: true,
          controller: _controller,
          bottomBouncing: true,
          header: LogoHeader(),
          onRefresh: () async {
            symbolLogic.initFuture().whenComplete(() {
              _controller.finishRefresh();
            });
          },
        ),
      );
    });
  }

  Widget _getTopBarWidget(logic) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      textDirection: TextDirection.ltr,
      children: [
        IconButton(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onPressed: logic.onOpenCustomerService,
          icon: ImageUtil.getAssetsImage('account_user_image', width: 28, height: 28),
        ),
        new Expanded(
          flex: 1,
          child: Container(
            height: 32,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: kbgSearch,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  ImageUtil.getAssetsImage("search_icon", width: 14, height: 14),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    S.of(context).homeSearch,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: kTextColorSearch,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        IconButton(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onPressed: logic.onOpenCustomerService,
          icon: ImageUtil.getAssetsImage('information_icon', width: 28, height: 28),
        )
      ],
    );
  }

  List<Widget> _getPageContent(state, HomeLogic logic) {
    return [
      _customBanner(state),
      _Notice(state),
      SelectedMarkets(),
      Container(
        width: double.infinity,
        height: 8,
        color: kBgGrayColor,
      ),
      _quickBuy(state),
      Container(
        width: double.infinity,
        height: 8,
        color: kBgGrayColor,
      ),
      _indexTool(state),
      Container(
        width: double.infinity,
        height: 8,
        color: kBgGrayColor,
      ),
      IndexTabbar(),
      IndexTabbarView(),
    ];
  }

  Widget _customBanner(state) {
    return Container(
      height: 132,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      child: new Swiper(
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () => {print("点击了$index")},
            child: Container(
              padding: EdgeInsets.fromLTRB(14, 0, 14, 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: CachedNetworkImage(
                  imageUrl: state.bannerImages[index],
                  fit: BoxFit.fitHeight,
                  placeholder: (context, url) => Container(
                      decoration: new BoxDecoration(
                    color: Colors.grey,
                  )),
                  errorWidget: (context, url, error) => Image.asset(
                    'assets/images/default_banner_image.png',
                    // 在项目中添加图片文件夹
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
            ),
          );
        },
        itemCount: state.bannerImages.length,
        pagination: new SwiperCustomPagination(
          builder: (BuildContext context, SwiperPluginConfig config) {
            return MySwiperPagination(swiper_length: state.bannerImages.length, swiper_index: config.activeIndex);
          },
        ),
        autoplay: true,
        autoplayDelay: 5000,
      ),
    );
  }

  Widget _Notice(state) {
    return Container(
      margin: EdgeInsets.fromLTRB(14, 0, 14, 0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1, color: kDividerColor),
        ),
      ),
      child: Row(
        children: [
          ImageUtil.getAssetsImage('home_news_image', width: 16, height: 16),
          Expanded(
            flex: 1,
            child: Container(
              height: 30,
              child: new Swiper(
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    child: ConstrainedBox(
                      constraints: BoxConstraints.expand(),
                      child: Stack(
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: 8),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              state.newsData[index],
                              // overflow: TextOverflow.ellipsis,
                              softWrap: false,
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                            width: double.infinity,
                            height: double.infinity,
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              width: 20,
                              height: 30,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.centerRight,
                                  end: Alignment.centerLeft,
                                  colors: [
                                    Colors.white,
                                    Color.fromRGBO(255, 255, 255, 0.3),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () => {},
                  );
                },
                itemCount: state.newsData.length,
                autoplay: true,
                scrollDirection: Axis.vertical,
                autoplayDelay: 4000,
              ),
            ),
          ),
          Container(
            width: 30,
            child: IconButton(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              padding: EdgeInsets.only(right: 0, left: 0),
              alignment: Alignment.centerRight,
              icon: ImageUtil.getAssetsImage('home_notice_more', width: 22, height: 22),
              onPressed: () => {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _quickBuy(state) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(left: 20, top: 15, right: 0, bottom: 15),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: Stack(
              children: [
                Container(
                  child: ImageUtil.getAssetsImage(
                    'otc_receivables_bank_card',
                    width: 20,
                    height: 20,
                  ),
                  margin: EdgeInsets.only(left: 15),
                ),
                Container(
                  child: ImageUtil.getAssetsImage(
                    'otc_receivables_wechat',
                    width: 20,
                    height: 20,
                  ),
                  margin: EdgeInsets.only(top: 15),
                ),
                Container(
                  child: ImageUtil.getAssetsImage(
                    'otc_receivables_zhifubao',
                    width: 20,
                    height: 20,
                  ),
                  margin: EdgeInsets.only(top: 15, left: 28),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  S.of(context).indexQuick,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: kTextColor,
                  ),
                ),
                SizedBox(
                  height: 3,
                ),
                Text(
                  S.of(context).indexQuickContent,
                  style: TextStyle(
                    fontSize: 11,
                    color: kTextColorSearch,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ImageUtil.getAssetsImage(
            "home_otc_enter",
            height: 40,
            fit: BoxFit.fitHeight,
          ),
        ],
      ),
    );
  }

  Widget _indexTool(state) {
    List<Widget> list = [];
    state.listTools.forEach(
      (item) => {
        list.add(
          Column(
            children: [
              SizedBox(
                height: 8,
              ),
              ImageUtil.getAssetsImage(item['icon'], height: 30, fit: BoxFit.cover),
              SizedBox(
                height: 6,
              ),
              Text(
                item['title'],
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      },
    );
    return Container(
      padding: EdgeInsets.only(top: 10, bottom: 10),
      child: Column(
        children: [
          GridView(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
            ),
            children: list,
          ),
          Stack(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(14, 14, 14, 0),
                child: ImageUtil.getAssetsImage("index_savings_cn_bg", width: double.infinity, fit: BoxFit.fitWidth),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(30, 5, 14, 0),
                child: ImageUtil.getAssetsImage("index_saving_cn_img", height: 50, fit: BoxFit.fitHeight),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(90, 14, 14, 0),
                child: ImageUtil.getAssetsImage("index_savings_chinese", height: 45, fit: BoxFit.fitHeight),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(0, 20, 20, 0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: ImageUtil.getAssetsImage("index_savings_cn_butten", height: 30, fit: BoxFit.fitHeight),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SelectedMarkets extends StatelessWidget {
  final logic = Get.isRegistered<HomeLogic>() ? Get.find<HomeLogic>() : Get.put(HomeLogic());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeLogic>(
      id: "indexSelectedTicker",
      builder: (logic) {
        late List<Widget> selectedChildred = [];
        late List<String> selectedKeys = logic.state.indexSelectedTicker.keys.toList();
        for (int i = 0; i < selectedKeys.length; i++) {
          double close = logic.state.indexSelectedTicker[selectedKeys[i]]!.close;
          double open = logic.state.indexSelectedTicker[selectedKeys[i]]!.open;
          String increase = ((close - open) / open * 100).toStringAsFixed(2);
          String usdPrice = (close * logic.state.indexSelectedTicker['USDT/HUSD']!.close).toStringAsFixed(2);
          String market = logic.state.indexSelectedTicker[selectedKeys[i]]!.symbol;
          selectedChildred.add(
            GestureDetector(
              onTap: () => {logic.toDetail(market)},
              child: Container(
                padding: EdgeInsets.fromLTRB(14, 10, 2, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          selectedKeys[i],
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(
                          width: 3,
                        ),
                        Text(
                          "${close - open > 0 ? '+' : ''}${increase}%",
                          style: TextStyle(
                            fontSize: 11,
                            color: close - open > 0 ? kTextColorIncreaseUp : kTextColorIncreaseDown,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Text(
                      "$close",
                      style: TextStyle(
                        fontSize: 18,
                        color: close - open > 0 ? kTextColorIncreaseUp : kTextColorIncreaseDown,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Text(
                      "\$$usdPrice",
                      style: TextStyle(
                        fontSize: 11,
                        color: kTextColorSearch,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        return NotificationListener(
          onNotification: logic.handleScrollNotification,
          child: Stack(
            children: [
              Container(
                height: 88,
                child: ListView(
                  physics: new BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  children: selectedChildred,
                ),
              ),
              // 滚动条
              Container(
                height: 82,
                alignment: Alignment.bottomCenter,
                margin: EdgeInsets.only(bottom: 8),
                child: Container(
                  alignment: Alignment(logic.state.alignmentPopularX, 1),
                  width: 30,
                  height: 2,
                  color: Color(0xffe5e5e8),
                  child: Container(
                    width: 15,
                    height: 2,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class IndexTabbar extends StatefulWidget {
  const IndexTabbar({Key? key}) : super(key: key);

  @override
  _IndexTabbarState createState() => _IndexTabbarState();
}

class _IndexTabbarState extends State<IndexTabbar> with TickerProviderStateMixin {
  final logic = Get.isRegistered<HomeLogic>() ? Get.find<HomeLogic>() : Get.put(HomeLogic());
  final state = Get.isRegistered<HomeLogic>() ? Get.find<HomeLogic>().state : Get.put(HomeLogic().state);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    state.tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return TabBar(
      tabs: [
        Tab(
          text: S.of(context).indexTabbar1,
        ),
        Tab(
          text: S.of(context).indexTabbar2,
        ),
        Tab(
          text: S.of(context).indexTabbar3,
        ),
      ],
      controller: state.tabController,
      unselectedLabelColor: kTextColorSearch,
      labelColor: kPrimaryColor,
      indicatorColor: kPrimaryColor,
      labelStyle: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
      ),
      onTap: logic.ChangeTabIndex,
    );
  }
}

class IndexTabbarView extends StatefulWidget {
  const IndexTabbarView({Key? key}) : super(key: key);

  @override
  _IndexTabbarViewState createState() => _IndexTabbarViewState();
}

class _IndexTabbarViewState extends State<IndexTabbarView> {
  final logic = Get.isRegistered<HomeLogic>() ? Get.find<HomeLogic>() : Get.put(HomeLogic());
  final state = Get.isRegistered<HomeLogic>() ? Get.find<HomeLogic>().state : Get.put(HomeLogic().state);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeLogic>(
        id: "indexTabbarView",
        builder: (logic) {
          return SizedBox(
            width: double.infinity,
            height: 600,
            child: IndexedStack(
              index: state.tabControllerIndex,
              children: [
                _IncreaseList(),
                _getAmoutList(),
                _getNewCoinList(),
              ],
            ),
          );
        });
  }

  Widget _IncreaseList() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(left: 20, top: 10, bottom: 10, right: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'USDT交易对',
                style: TextStyle(
                  color: kTextColorSearch,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  '最新价',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: kTextColorSearch,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                width: 110,
                child: Text(
                  '涨跌幅',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: kTextColorSearch,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 20, top: 0, bottom: 10, right: 20),
          width: double.infinity,
          child: Column(
            children: state.indexTopChange
                .map((item) {
                  int prec = 0;
                  if(item.close.toString().indexOf('.') > -1){
                    prec = item.close.toString().split('.')[1].length > 10 ? 10 : item.close.toString().split('.')[1].length;
                  }
                  return InkWell(
                    onTap: () {
                      logic.toDetail(item.baseCurrency + item.quoteCurrency);
                    },
                    child: Container(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: Row(
                        children: [
                          Row(
                            children: [
                              Text(
                                item.baseCurrency.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xff14191f),
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              Container(
                                child: Text(
                                  ' /' + item.quoteCurrency.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: kTextColorSearch,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                margin: EdgeInsets.only(bottom: 2),
                              ),
                            ],
                            crossAxisAlignment: CrossAxisAlignment.end,
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              item.close.toStringAsFixed(prec),
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xff14191f),
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          Container(
                            width: 80,
                            height: 32,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(6.0)),
                              color: item.change > 0 ? kTextColorIncreaseUp : kTextColorRed,
                            ),
                            child: Text(
                              "${(item.change).toStringAsFixed(2)}%",
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            alignment: Alignment.center,
                          ),
                        ],
                      ),
                    ),
                  );
                })
                .cast<Widget>()
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _getAmoutList() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(left: 20, top: 10, bottom: 10, right: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '名称',
                style: TextStyle(
                  color: kTextColorSearch,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  '最新价(USD)',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: kTextColorSearch,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                width: 110,
                child: Text(
                  '24H成交额(USD)',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: kTextColorSearch,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 20, top: 0, bottom: 10, right: 20),
          width: double.infinity,
          child: Column(
            children: state.indexTopValue
                .map((item) {
                  var amountString = item['totalVal'].toString();
                  if (item['totalVal'] >= 100000000) {
                    amountString = "${(item['totalVal'] / 100000000).toStringAsFixed(2)}亿";
                  } else if (item['totalVal'] >= 10000000) {
                    amountString = "${(item['totalVal'] / 10000000).toStringAsFixed(2)}千万";
                  } else if (item['totalVal'] >= 1000000) {
                    amountString = "${(item['totalVal'] / 1000000).toStringAsFixed(2)}百万";
                  } else if (item['totalVal'] >= 10000) {
                    amountString = "${(item['totalVal'] / 10000).toStringAsFixed(2)}万";
                  } else {
                    amountString = item['totalVal'].toStringAsFixed(2);
                  }
                  return InkWell(
                    onTap: () {
                      logic.toDetail(item['symbol'].toLowerCase() + 'usdt');
                    },
                    child: Container(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: Row(
                        children: [
                          Text(
                            item['symbol'].toUpperCase(),
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xff14191f),
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              '${item["usdprice"]}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xff14191f),
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          Container(
                            width: 80,
                            height: 32,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(6.0)),
                              color: Color(0xffeff6fe),
                            ),
                            child: Text(
                              amountString,
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: 15,
                                color: kPrimaryColor,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            alignment: Alignment.center,
                          ),
                        ],
                      ),
                    ),
                  );
                })
                .cast<Widget>()
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _getNewCoinList() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(left: 20, top: 10, bottom: 10, right: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '名称',
                style: TextStyle(
                  color: kTextColorSearch,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  '最新价(USD)',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: kTextColorSearch,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                width: 110,
                child: Text(
                  '涨跌幅',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: kTextColorSearch,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 20, top: 0, bottom: 10, right: 20),
          width: double.infinity,
          child: Column(
            children: state.indexTopNewCoin
                .map((item) {
                  return InkWell(
                    onTap: () {
                      logic.toDetail(item.baseCurrency + item.quoteCurrency);
                    },
                    child: Container(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: Row(
                        children: [
                          Row(
                            children: [
                              Text(
                                item.baseCurrency.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xff14191f),
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              Container(
                                child: Text(
                                  ' /' + item.quoteCurrency.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: kTextColorSearch,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                margin: EdgeInsets.only(bottom: 2),
                              ),
                            ],
                            crossAxisAlignment: CrossAxisAlignment.end,
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              '${item.close}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color(0xff14191f),
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          Container(
                            width: 80,
                            height: 32,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(6.0)),
                              color: item.change > 0 ? kTextColorIncreaseUp : kTextColorRed,
                            ),
                            child: Text(
                              "${(item.change).toStringAsFixed(2)}%",
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            alignment: Alignment.center,
                          ),
                        ],
                      ),
                    ),
                  );
                })
                .cast<Widget>()
                .toList(),
          ),
        ),
      ],
    );
  }
}
