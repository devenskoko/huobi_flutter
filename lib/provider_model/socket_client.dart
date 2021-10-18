import 'dart:convert';
import 'package:get/get.dart';
import 'package:archive/archive.dart';
import 'package:huobi_flutter/config/event_bus.dart';
import 'package:huobi_flutter/config/net/my_api.dart';
import 'package:huobi_flutter/provider_model/symbols.dart';
import 'package:huobi_flutter/widgetpage/hq_detail/logic.dart';
import 'package:huobi_flutter/widgets/chart/logic.dart';
import 'package:web_socket_channel/io.dart';

class socketLogic {
  static HqDetailLogic hqDetailLogic = Get.find<HqDetailLogic>();
  static ChartLogic chartLogic = Get.find<ChartLogic>();
  static late IOWebSocketChannel channel;

  static bool connected = false;

  static void initSocket() {
    SocketClient.create();
    channel = SocketClient.channel;

    channel.stream.listen((message) {
      messageHandle(message);
    });

    TickerSubscribe();
  }

  static messageHandle(message) {
    var decodeBytes = GZipDecoder().decodeBytes(message);
    var data = String.fromCharCodes(decodeBytes);
    Map msg = json.decode(data);
    if (!connected) {
      TickerSubscribe();
    }
    connected = true;
    if (msg.containsKey('ping')) {
      String pong = '{"pong":"${msg['ping']}"}';
      sub(pong);
    } else if (msg.containsKey('ch') && msg["ch"].indexOf('ticker') > -1) {
      symbolLogic.SingleUpdateTicker(msg);
    } else if (msg.containsKey('ch') && msg["ch"].indexOf('depth') > -1) {
      eventBus.fire(new SocketEvent(msg));
    } else if (msg.containsKey('ch') && msg["ch"].indexOf('kline') > -1) {
      eventBus.fire(new KLineEvent(msg));
    } else if (msg.containsKey('ch') && msg["ch"].indexOf('trade.detail') > -1) {
      eventBus.fire(new HistoryOrderEvent(msg));
    }
  }

  static TickerSubscribe() {
    // 订阅100个 太多很费vpn流量
    int num = 0;
    symbolLogic.symbols.forEach((item) {
      if (item.state == 'online') {
        num++;
        if (num <= 500) {
          String ticker = '{"sub": "market.${item.symbol}.ticker"}';
          sub(ticker);
        }
      }
    });
  }

  static sub(str) {
    channel.sink.add(str);
  }

  static unsub(str) {
    channel.sink.add(str);
  }
}
