class market_trade {
  double? id;
  late int ts;
  int? tradeId;
  double? amount;
  double? price;
  String? direction;

  market_trade({this.id, required this.ts, this.tradeId, this.amount, required this.price, required this.direction});

  market_trade.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    ts = json['ts'];
    tradeId = json['trade-id'];
    amount = json['amount'];
    price = json['price'];
    direction = json['direction'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['ts'] = this.ts;
    data['trade-id'] = this.tradeId;
    data['amount'] = this.amount;
    data['price'] = this.price;
    data['direction'] = this.direction;
    return data;
  }
}
