class Kline {
  int? id;
  double? open;
  double? close;
  double? low;
  double? high;
  double? amount;
  double? vol;
  dynamic? count;

  Kline(
      {required this.id,
        required this.open,
        required this.close,
        required this.low,
        required this.high,
        required this.amount,
        required this.vol,
        required this.count});

  Kline.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    open = json['open'];
    close = json['close'];
    low = json['low'];
    high = json['high'];
    amount = json['amount'];
    vol = json['vol'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['open'] = this.open;
    data['close'] = this.close;
    data['low'] = this.low;
    data['high'] = this.high;
    data['amount'] = this.amount;
    data['vol'] = this.vol;
    data['count'] = this.count;
    return data;
  }
}