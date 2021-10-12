class market_tickers {
  String symbol = '';
  double open = 0.0;
  double high = 0.0;
  double low = 0.0;
  double close = 0.0;
  double amount = 0.0;
  double? vol;
  int? count;
  double? bid;
  double? bidSize;
  double? ask;
  double? askSize;
  double change = 0.0;
  double value = 0.0;
  String baseCurrency = '';
  String quoteCurrency = '';

  market_tickers({
    required this.symbol,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.amount,
    this.vol,
    this.count,
    this.bid,
    this.bidSize,
    this.ask,
    this.askSize,
  });

  market_tickers.fromJson(Map<String, dynamic> json) {
    symbol = json['symbol'];
    open = json['open'];
    high = json['high'];
    low = json['low'];
    close = json['close'];
    amount = json['amount'];
    vol = json['vol'];
    count = json['count'];
    bid = json['bid'];
    bidSize = json['bidSize'];
    ask = json['ask'];
    askSize = json['askSize'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['symbol'] = this.symbol;
    data['open'] = this.open;
    data['high'] = this.high;
    data['low'] = this.low;
    data['close'] = this.close;
    data['amount'] = this.amount;
    data['vol'] = this.vol;
    data['count'] = this.count;
    data['bid'] = this.bid;
    data['bidSize'] = this.bidSize;
    data['ask'] = this.ask;
    data['askSize'] = this.askSize;
    return data;
  }
}
