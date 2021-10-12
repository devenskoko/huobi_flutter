import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:huobi_flutter/generated/l10n.dart';
import 'package:huobi_flutter/models/market_tickers.dart';

class HomeState {
  late List bannerImages;
  late List newsData;
  late double alignmentPopularX;
  late List<Map<String, String>> listTools;
  late TabController tabController;
  late int tabControllerIndex;
  late Map<String, market_tickers> indexSelectedTicker;
  late List<String> indexSelected;
  late List<String> newCoins;
  late List<String> quoteCurrency;
  late List<market_tickers> indexTopChange; //涨幅榜
  late List indexTopValue; // 成交额榜
  late List<market_tickers> indexTopNewCoin; // 新币榜

  HomeState() {
    bannerImages = [
      "https://flutter-huobi.oss-cn-beijing.aliyuncs.com/80e33e08-d7d3-49ad-b0af-1d113f8b5074.jpg?versionId=CAEQGRiBgMDFiZuN3hciIGEzMjJhOTEyMDJmZTQ5NGRhYWQzYTg5Mzk4OWIwOTZk",
      "https://flutter-huobi.oss-cn-beijing.aliyuncs.com/bb4dc165-5097-4076-8089-ad1db430ca1f.jpg?versionId=CAEQGRiBgMDMjZqN3hciIDJlZDRmMTE2N2FiYjRkOGI5YjYwZmI4MmMxYzJkZWMz",
    ];

    newsData = [
      "Huobi Gobal定于5月13日18:30开放03币币交易",
      "关于支持对TRX、BTT、JST持有者空投NFT的公告",
      "火币将于5月20日14:00暂停ERC20代币提现",
      "Huobi 创新区新增币种XCH",
    ];

    alignmentPopularX = -1.0;

    listTools = [
      {"icon": "index_tools_01", "title": "邀请奖励"},
      {"icon": "index_tools_02", "title": "充币"},
      {"icon": "index_tools_03", "title": "Huobi Earn"},
      {"icon": "index_tools_04", "title": "积分中心"},
      {"icon": "index_tools_05", "title": "联系客服"},
      {"icon": "index_tools_06", "title": "波卡生态板块"},
      {"icon": "index_tools_07", "title": "NFT板块"},
      {"icon": "index_tools_08", "title": "HECO专区"},
      {"icon": "index_tools_09", "title": "USDT合约"},
      {"icon": "index_tools_10", "title": "网络策略"},
    ];

    tabControllerIndex = 0;

    indexSelected = ['BTC/USDT', 'ETH/USDT', 'HT/USDT', 'DOTUSDT', 'USDT/HUSD'];
    newCoins = ['DYDX', 'XPRT', 'TALK', 'AGLD', 'RLY', 'PUSH', 'EPIK', 'COTI', 'SXP', 'YGG'];
    quoteCurrency = [];
    indexSelectedTicker = {};
    indexTopChange = [];
    indexTopValue = [];
    indexTopNewCoin = [];
  }
}
