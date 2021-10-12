class common_symbols {
  String? baseCurrency;
  String? quoteCurrency;
  int? pricePrecision;
  int? amountPrecision;
  String? symbolPartition;
  String? symbol;
  String? state;
  int? valuePrecision;
  dynamic? minOrderValue;
  dynamic? limitOrderMinOrderAmt;
  dynamic? limitOrderMaxOrderAmt;
  dynamic? sellMarketMinOrderAmt;
  dynamic? sellMarketMaxOrderAmt;
  dynamic? buyMarketMaxOrderValue;
  String? apiTrading;

  common_symbols(
      {this.baseCurrency,
        this.quoteCurrency,
        this.pricePrecision,
        this.amountPrecision,
        this.symbolPartition,
        this.symbol,
        this.state,
        this.valuePrecision,
        this.minOrderValue,
        this.limitOrderMinOrderAmt,
        this.limitOrderMaxOrderAmt,
        this.sellMarketMinOrderAmt,
        this.sellMarketMaxOrderAmt,
        this.buyMarketMaxOrderValue,
        this.apiTrading});

  common_symbols.fromJson(Map<String, dynamic> json) {
    baseCurrency = json['base-currency'];
    quoteCurrency = json['quote-currency'];
    pricePrecision = json['price-precision'];
    amountPrecision = json['amount-precision'];
    symbolPartition = json['symbol-partition'];
    symbol = json['symbol'];
    state = json['state'];
    valuePrecision = json['value-precision'];
    minOrderValue = json['min-order-value'];
    limitOrderMinOrderAmt = json['limit-order-min-order-amt'];
    limitOrderMaxOrderAmt = json['limit-order-max-order-amt'];
    sellMarketMinOrderAmt = json['sell-market-min-order-amt'];
    sellMarketMaxOrderAmt = json['sell-market-max-order-amt'];
    buyMarketMaxOrderValue = json['buy-market-max-order-value'];
    apiTrading = json['api-trading'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['base-currency'] = this.baseCurrency;
    data['quote-currency'] = this.quoteCurrency;
    data['price-precision'] = this.pricePrecision;
    data['amount-precision'] = this.amountPrecision;
    data['symbol-partition'] = this.symbolPartition;
    data['symbol'] = this.symbol;
    data['state'] = this.state;
    data['value-precision'] = this.valuePrecision;
    data['min-order-value'] = this.minOrderValue;
    data['limit-order-min-order-amt'] = this.limitOrderMinOrderAmt;
    data['limit-order-max-order-amt'] = this.limitOrderMaxOrderAmt;
    data['sell-market-min-order-amt'] = this.sellMarketMinOrderAmt;
    data['sell-market-max-order-amt'] = this.sellMarketMaxOrderAmt;
    data['buy-market-max-order-value'] = this.buyMarketMaxOrderValue;
    data['api-trading'] = this.apiTrading;
    return data;
  }
}


