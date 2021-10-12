import 'dart:convert';
import 'dart:developer';

void tryCatch(Function? f) {
  try {
    f?.call();
  } catch (e, stack) {
    log('$e');
    log('$stack');
  }
}

class FFConvert {
  FFConvert._();
  static T? Function<T extends Object?>(dynamic value) convert =
  <T>(dynamic value) {
    if (value == null) {
      return null;
    }
    return json.decode(value.toString()) as T?;
  };
}

T? asT<T extends Object?>(dynamic value, [T? defaultValue]) {
  if (value is T) {
    return value;
  }
  try {
    if (value != null) {
      final String valueS = value.toString();
      if ('' is T) {
        return valueS as T;
      } else if (0 is T) {
        return int.parse(valueS) as T;
      } else if (0.0 is T) {
        return double.parse(valueS) as T;
      } else if (false is T) {
        if (valueS == '0' || valueS == '1') {
          return (valueS == '1') as T;
        }
        return (valueS == 'true') as T;
      } else {
        return FFConvert.convert<T>(value);
      }
    }
  } catch (e, stackTrace) {
    log('asT<$T>', error: e, stackTrace: stackTrace);
    return defaultValue;
  }

  return defaultValue;
}

class Depth {
  const Depth({
    this.ts,
    this.version,
    this.bids,
    this.asks,
  });

  factory Depth.fromJson(Map<String, dynamic> jsonRes) {
    final List<List<double>>? bids =
    jsonRes['bids'] is List ? <List<double>>[] : null;
    if (bids != null) {
      for (final dynamic item0 in asT<List<dynamic>>(jsonRes['bids'])!) {
        if (item0 != null) {
          final List<double> items1 = <double>[];
          for (final dynamic item1 in asT<List<dynamic>>(item0)!) {
            if (item1 != null) {
              tryCatch(() {
                items1.add(asT<double>(item1)!);
              });
            }
          }
          bids.add(items1);
        }
      }
    }

    final List<List<double>>? asks =
    jsonRes['asks'] is List ? <List<double>>[] : null;
    if (asks != null) {
      for (final dynamic item0 in asT<List<dynamic>>(jsonRes['asks'])!) {
        if (item0 != null) {
          final List<double> items1 = <double>[];
          for (final dynamic item1 in asT<List<dynamic>>(item0)!) {
            if (item1 != null) {
              tryCatch(() {
                items1.add(asT<double>(item1)!);
              });
            }
          }
          asks.add(items1);
        }
      }
    }
    return Depth(
      ts: asT<int?>(jsonRes['ts']),
      version: asT<int?>(jsonRes['version']),
      bids: bids,
      asks: asks,
    );
  }

  final int? ts;
  final int? version;
  final List<List<double>>? bids;
  final List<List<double>>? asks;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'ts': ts,
    'version': version,
    'bids': bids,
    'asks': asks,
  };
}
