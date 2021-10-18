import 'package:event_bus/event_bus.dart';
import 'package:huobi_flutter/models/market_tickers.dart';

//Bus初始化
EventBus eventBus = EventBus();

class TickersEvent {
  late List<market_tickers> tickers;
  TickersEvent(this.tickers);
}

class SocketEvent {
  late Map socketmsg;
  SocketEvent(this.socketmsg);
}

class KLineEvent {
  late Map klinemsg;
  KLineEvent(this.klinemsg);
}

class HistoryOrderEvent {
  late Map socketmsg;
  HistoryOrderEvent(this.socketmsg);
}