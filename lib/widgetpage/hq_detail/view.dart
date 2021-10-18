import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:huobi_flutter/constants/color_constants.dart';
import 'package:huobi_flutter/generated/l10n.dart';
import 'package:huobi_flutter/manager/device_manager.dart';
import 'package:huobi_flutter/utils/ImageUtil.dart';
import 'package:huobi_flutter/widgets/chart/view.dart';
import 'logic.dart';
import 'package:share/share.dart';
import 'package:date_format/date_format.dart' hide S;

class HqDetailPage extends StatefulWidget {
  const HqDetailPage({Key? key}) : super(key: key);

  @override
  _HqDetailPageState createState() => _HqDetailPageState();
}

class _HqDetailPageState extends State<HqDetailPage> with TickerProviderStateMixin {
  // 接收参数
  String market = Get.arguments;

  final logic = Get.find<HqDetailLogic>();
  final state = Get.find<HqDetailLogic>().state;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    state.tabController = TabController(vsync: this, length: 3);
    state.tabController.addListener(() {
      setState(() {
        state.tabControllerIndex = state.tabController.index;
      });
    });

    logic.updateMarket(market);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    logic.unsubscribe();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 40,
        title: Text(
          market.toUpperCase(),
          style: TextStyle(
            color: kTextColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(
          color: kTextColor,
        ),
        elevation: 0,
        centerTitle: true,
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {},
                child: Container(
                  padding: EdgeInsets.only(right: 16),
                  child: FaIcon(
                    FontAwesomeIcons.expandArrowsAlt,
                    size: 18,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Share.share(market + 'share');
                },
                child: Container(
                  padding: EdgeInsets.only(right: 16),
                  child: FaIcon(
                    FontAwesomeIcons.shareSquare,
                    size: 18,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
      body: CustomScrollView(
        physics: ScrollPhysics(),
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: DetailTopWidget(),
          ),
          SliverToBoxAdapter(
            child: ChartWidget(market, state.prec),
          ),
          SliverToBoxAdapter(
            child: Container(
              height: 10,
              width: double.infinity,
              color: kBgGrayColor,
            ),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: _SliverAppBarDelegate(
              maxHeight: 45,
              minHeight: 45,
              child: Container(
                color: Colors.white,
                child: Stack(
                  children: [
                    Align(
                      child: Container(
                        height: 0.1,
                        width: double.infinity,
                        color: kTextGrayBlueColor,
                      ),
                      alignment: Alignment.bottomCenter,
                    ),
                    TabBar(
                      unselectedLabelColor: kTextGrayBlueColor,
                      indicatorColor: kTextColorKChartTab,
                      labelColor: kTextColorKChartTab,
                      labelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                      controller: state.tabController,
                      tabs: <Widget>[
                        Tab(
                          text: S.of(context).orderBook,
                        ),
                        Tab(
                          text: S.of(context).filled,
                        ),
                        Tab(
                          text: S.of(context).introduction,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(child: _getBottomWidaget(state)),
        ],
      ),
      bottomNavigationBar: Container(
        height: 68,
        width: double.infinity,
        padding: EdgeInsets.only(bottom: 14, top: 12, right: 12, left: 12),
        decoration: new BoxDecoration(
          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.5), blurRadius: 10.0)],
          color: Colors.white,
        ),
        child: Row(
          children: [
            TextButton(
              onPressed: () {},
              child: Text(
                S.of(context).buy,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
              ),
              style: ButtonStyle(
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                minimumSize: MaterialStateProperty.all(Size(93, double.infinity)),
                backgroundColor: MaterialStateProperty.all(kTextColorIncreaseUp),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                S.of(context).sell,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
              ),
              style: ButtonStyle(
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                minimumSize: MaterialStateProperty.all(Size(93, double.infinity)),
                backgroundColor: MaterialStateProperty.all(kTextColorIncreaseDown),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        ImageUtil.getAssetsImage('kline_laver_button', height: 22, fit: BoxFit.fitHeight),
                        SizedBox(
                          height: 2,
                        ),
                        Text(
                          S.of(context).margin,
                          style: TextStyle(
                            color: kTextColorOrange,
                            fontSize: 10,
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        ImageUtil.getAssetsImage('kline_icon_remind_night', height: 22, fit: BoxFit.fitHeight, color: kTextColor),
                        SizedBox(
                          height: 2,
                        ),
                        Text(
                          S.of(context).alert,
                          style: TextStyle(
                            color: kTextColor,
                            fontSize: 10,
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        ImageUtil.getAssetsImage('kline_icon_collect_night', height: 22, fit: BoxFit.fitHeight, color: kTextColor),
                        SizedBox(
                          height: 2,
                        ),
                        Text(
                          S.of(context).favs,
                          style: TextStyle(
                            color: kTextColor,
                            fontSize: 10,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getBottomWidaget(state) {
    switch (state.tabControllerIndex) {
      case 0:
        return OrderBookWidgt();
      case 1:
        return HistoryOrder();
      case 2:
        return Container(
          constraints: BoxConstraints(minHeight: 500),
        );
      default:
        return Container(
          constraints: BoxConstraints(minHeight: 500),
        );
    }
  }
}

class DetailTopWidget extends StatelessWidget {
  final logic = Get.find<HqDetailLogic>();
  final state = Get.find<HqDetailLogic>().state;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HqDetailLogic>(
      id: "detailTop",
      builder: (logic) {
        if (state.marketData.isEmpty) {
          return Text('loading');
        }
        var change = ((state.marketData['close'] - state.marketData['open']) / state.marketData['open'] * 100);
        var deal = state.marketData['close'] * state.marketData['amount'];
        var vol = state.marketData['amount'];
        var volString = logic.numFormat(vol);
        var dealString = logic.numFormat(deal);

        return Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    state.marketData['close'].toString(),
                    style: TextStyle(
                      color: change > 0 ? kTextColorIncreaseUp : kTextColorRed,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Row(
                    children: [
                      Text(
                        "≈${(state.marketData['close'] * state.marketData['usdprice']).toStringAsFixed(state.prec)} USD",
                        style: TextStyle(
                          color: defaultColor,
                          fontSize: 13,
                        ),
                      ),
                      SizedBox(
                        width: 2,
                      ),
                      Text(
                        " ${change > 0 ? '+' + change.toStringAsFixed(state.prec) : change.toStringAsFixed(state.prec)} %",
                        style: TextStyle(
                          color: change > 0 ? kTextColorIncreaseUp : kTextColorRed,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                width: 100,
                margin: EdgeInsets.only(top: 10),
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 45,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                S.of(context).HHight24,
                                style: TextStyle(
                                  color: defaultColor,
                                  fontSize: 10,
                                ),
                              ),
                              SizedBox(
                                width: 2,
                              ),
                              Text(
                                "${state.marketData['high']}",
                                style: TextStyle(
                                  color: kTextColor,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          width: 45,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                S.of(context).HVol24,
                                style: TextStyle(
                                  color: defaultColor,
                                  fontSize: 10,
                                ),
                              ),
                              SizedBox(
                                width: 2,
                              ),
                              Text(
                                volString,
                                style: TextStyle(
                                  color: kTextColor,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 45,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                S.of(context).HLow24,
                                style: TextStyle(
                                  color: defaultColor,
                                  fontSize: 10,
                                ),
                              ),
                              SizedBox(
                                width: 2,
                              ),
                              Text(
                                "${state.marketData['low']}",
                                style: TextStyle(
                                  color: kTextColor,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          width: 45,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                S.of(context).H24,
                                style: TextStyle(
                                  color: defaultColor,
                                  fontSize: 10,
                                ),
                              ),
                              SizedBox(
                                width: 2,
                              ),
                              Text(
                                dealString,
                                style: TextStyle(
                                  color: kTextColor,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => this.minHeight;

  @override
  double get maxExtent => max(maxHeight, minHeight);

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight || minHeight != oldDelegate.minHeight || child != oldDelegate.child;
  }
}

class OrderBookWidgt extends StatelessWidget {
  const OrderBookWidgt({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var screenWidth = DeviceManager.getInstance().screenWidth;
    return GetBuilder<HqDetailLogic>(
      id: "orderBook",
      builder: (logic) {
        List<Widget> listOrderBook = [];
        double lastAmountBids = 0.0;
        double lastAmountAsks = 0.0;
        if (logic.state.asks.length != 0) {
          listOrderBook = List.generate(
            20,
            (index) {
              lastAmountBids += logic.state.bids[index].amount;
              lastAmountAsks += logic.state.asks[index].amount;
              return Stack(
                children: [
                  Positioned(
                    left: screenWidth / 2 - screenWidth / 2 * lastAmountBids / logic.state.bidsAmountTotal,
                    bottom: 0,
                    width: screenWidth / 2 * lastAmountBids / logic.state.bidsAmountTotal,
                    child: Container(
                      height: 32,
                      color: kTextColorIncreaseUp.withOpacity(0.1),
                    ),
                  ),
                  Positioned(
                    right: screenWidth / 2 - screenWidth / 2 * lastAmountAsks / logic.state.asksAmountTotal,
                    bottom: 0,
                    width: screenWidth / 2 * lastAmountAsks / logic.state.asksAmountTotal,
                    child: Container(
                      height: 32,
                      color: kTextColorIncreaseDown.withOpacity(0.1),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      children: [
                        Container(
                          width: 35,
                          height: 32,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "${index + 1}",
                            style: TextStyle(
                              color: defaultColor,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Container(
                          width: 80,
                          height: 32,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "${logic.state.bids[index].amount}",
                            style: TextStyle(
                              color: kTextColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            padding: EdgeInsets.only(right: 2),
                            alignment: Alignment.centerRight,
                            child: Text(
                              "${logic.state.bids[index].price}",
                              style: TextStyle(
                                color: kTextColorIncreaseUp,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            padding: EdgeInsets.only(left: 2),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "${logic.state.asks[index].price}",
                              style: TextStyle(
                                color: kTextColorIncreaseDown,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 80,
                          height: 32,
                          alignment: Alignment.centerRight,
                          child: Text(
                            "${logic.state.asks[index].amount}",
                            style: TextStyle(
                              color: kTextColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Container(
                          width: 35,
                          height: 32,
                          alignment: Alignment.centerRight,
                          child: Text(
                            "${index + 1}",
                            style: TextStyle(
                              color: defaultColor,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        }
        return Container(
          constraints: BoxConstraints(minHeight: 500),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    Container(
                      width: 35,
                      height: 35,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        S.of(context).orderBookBuy,
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 10,
                        ),
                      ),
                    ),
                    Container(
                      width: 100,
                      height: 35,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        S.of(context).orderBookAmount,
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 10,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          S.of(context).orderBookPrice,
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 100,
                      height: 35,
                      alignment: Alignment.centerRight,
                      child: Text(
                        S.of(context).orderBookAmount,
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 10,
                        ),
                      ),
                    ),
                    Container(
                      width: 35,
                      height: 35,
                      alignment: Alignment.centerRight,
                      child: Text(
                        S.of(context).orderBookSell,
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 6,
              ),
              Column(children: logic.state.asks.length == 0 ? [] : listOrderBook),
              SizedBox(
                height: 14,
              ),
            ],
          ),
        );
      },
    );
  }
}

class HistoryOrder extends StatelessWidget {
  const HistoryOrder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HqDetailLogic>(
        id: "historyOrder",
        builder: (logic) {
          List<Widget> listHistoryOrder = [];
          if (logic.state.historyOrder.length != 0) {
            listHistoryOrder = List.generate(20, (index) {
              return Row(
                children: [
                  Container(
                    width: 100,
                    height: 35,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "${formatDate(DateTime.fromMillisecondsSinceEpoch(logic.state.historyOrder[index].ts), [HH, ':', nn, ':', ss])}",
                      style: TextStyle(
                        color: kTextColor,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Container(
                    width: 100,
                    height: 35,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "${logic.state.historyOrder[index].direction == 'buy' ? S.of(context).buy : S.of(context).sell}",
                      style: TextStyle(
                        color: logic.state.historyOrder[index].direction == 'buy' ? kTextColorIncreaseUp : kTextColorIncreaseDown,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "${logic.state.historyOrder[index].price}",
                        style: TextStyle(
                          color: kTextColor,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 100,
                    height: 35,
                    alignment: Alignment.centerRight,
                    child: Text(
                      "${logic.state.historyOrder[index].amount!.toStringAsFixed(4)}",
                      style: TextStyle(
                        color: kTextColor,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              );
            });
          };
          return Container(
            constraints: BoxConstraints(minHeight: 500),
            padding: EdgeInsets.only(left: 12, right: 12),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 100,
                      height: 35,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        S.of(context).date,
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 10,
                        ),
                      ),
                    ),
                    Container(
                      width: 100,
                      height: 35,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        S.of(context).orderType,
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 10,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: Text(
                          S.of(context).orderBookPrice,
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 100,
                      height: 35,
                      alignment: Alignment.centerRight,
                      child: Text(
                        S.of(context).orderBookAmount,
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 2,
                ),
                Column(children: logic.state.historyOrder.length == 0 ? [] : listHistoryOrder),
                SizedBox(
                  height: 14,
                ),
              ],
            ),
          );
        }
    );
  }
}
