// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Huobi Globol`
  String get title {
    return Intl.message(
      'Huobi Globol',
      name: 'title',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get tabbar1 {
    return Intl.message(
      'Home',
      name: 'tabbar1',
      desc: '',
      args: [],
    );
  }

  /// `Markets`
  String get tabbar2 {
    return Intl.message(
      'Markets',
      name: 'tabbar2',
      desc: '',
      args: [],
    );
  }

  /// `Trade`
  String get tabbar3 {
    return Intl.message(
      'Trade',
      name: 'tabbar3',
      desc: '',
      args: [],
    );
  }

  /// `Derivatives`
  String get tabbar4 {
    return Intl.message(
      'Derivatives',
      name: 'tabbar4',
      desc: '',
      args: [],
    );
  }

  /// `Balances`
  String get tabbar5 {
    return Intl.message(
      'Balances',
      name: 'tabbar5',
      desc: '',
      args: [],
    );
  }

  /// `Search for coins`
  String get homeSearch {
    return Intl.message(
      'Search for coins',
      name: 'homeSearch',
      desc: '',
      args: [],
    );
  }

  /// `Quick money buying`
  String get indexQuick {
    return Intl.message(
      'Quick money buying',
      name: 'indexQuick',
      desc: '',
      args: [],
    );
  }

  /// `Support BTC, usdt, ETH, etc`
  String get indexQuickContent {
    return Intl.message(
      'Support BTC, usdt, ETH, etc',
      name: 'indexQuickContent',
      desc: '',
      args: [],
    );
  }

  /// `Top Gainers`
  String get indexTabbar1 {
    return Intl.message(
      'Top Gainers',
      name: 'indexTabbar1',
      desc: '',
      args: [],
    );
  }

  /// `VOL Leaders`
  String get indexTabbar2 {
    return Intl.message(
      'VOL Leaders',
      name: 'indexTabbar2',
      desc: '',
      args: [],
    );
  }

  /// `Newest`
  String get indexTabbar3 {
    return Intl.message(
      'Newest',
      name: 'indexTabbar3',
      desc: '',
      args: [],
    );
  }

  /// `Line`
  String get chartTab1 {
    return Intl.message(
      'Line',
      name: 'chartTab1',
      desc: '',
      args: [],
    );
  }

  /// `min`
  String get chartTab2 {
    return Intl.message(
      'min',
      name: 'chartTab2',
      desc: '',
      args: [],
    );
  }

  /// `h`
  String get chartTab3 {
    return Intl.message(
      'h',
      name: 'chartTab3',
      desc: '',
      args: [],
    );
  }

  /// `d`
  String get chartTab4 {
    return Intl.message(
      'd',
      name: 'chartTab4',
      desc: '',
      args: [],
    );
  }

  /// `w`
  String get chartTab5 {
    return Intl.message(
      'w',
      name: 'chartTab5',
      desc: '',
      args: [],
    );
  }

  /// `m`
  String get chartTab6 {
    return Intl.message(
      'm',
      name: 'chartTab6',
      desc: '',
      args: [],
    );
  }

  /// `Depth`
  String get chartTab7 {
    return Intl.message(
      'Depth',
      name: 'chartTab7',
      desc: '',
      args: [],
    );
  }

  /// `More`
  String get chartTabMore {
    return Intl.message(
      'More',
      name: 'chartTabMore',
      desc: '',
      args: [],
    );
  }

  /// `24HHight`
  String get HHight24 {
    return Intl.message(
      '24HHight',
      name: 'HHight24',
      desc: '',
      args: [],
    );
  }

  /// `24H Vol`
  String get HVol24 {
    return Intl.message(
      '24H Vol',
      name: 'HVol24',
      desc: '',
      args: [],
    );
  }

  /// `24HLow`
  String get HLow24 {
    return Intl.message(
      '24HLow',
      name: 'HLow24',
      desc: '',
      args: [],
    );
  }

  /// `24H`
  String get H24 {
    return Intl.message(
      '24H',
      name: 'H24',
      desc: '',
      args: [],
    );
  }

  /// `Date`
  String get date {
    return Intl.message(
      'Date',
      name: 'date',
      desc: '',
      args: [],
    );
  }

  /// `Open`
  String get open {
    return Intl.message(
      'Open',
      name: 'open',
      desc: '',
      args: [],
    );
  }

  /// `H`
  String get high {
    return Intl.message(
      'H',
      name: 'high',
      desc: '',
      args: [],
    );
  }

  /// `L`
  String get low {
    return Intl.message(
      'L',
      name: 'low',
      desc: '',
      args: [],
    );
  }

  /// `Close`
  String get close {
    return Intl.message(
      'Close',
      name: 'close',
      desc: '',
      args: [],
    );
  }

  /// `Change`
  String get change {
    return Intl.message(
      'Change',
      name: 'change',
      desc: '',
      args: [],
    );
  }

  /// `Change%`
  String get change_ {
    return Intl.message(
      'Change%',
      name: 'change_',
      desc: '',
      args: [],
    );
  }

  /// `Executed`
  String get executed {
    return Intl.message(
      'Executed',
      name: 'executed',
      desc: '',
      args: [],
    );
  }

  /// `Buy`
  String get buy {
    return Intl.message(
      'Buy',
      name: 'buy',
      desc: '',
      args: [],
    );
  }

  /// `Sell`
  String get sell {
    return Intl.message(
      'Sell',
      name: 'sell',
      desc: '',
      args: [],
    );
  }

  /// `Margin`
  String get margin {
    return Intl.message(
      'Margin',
      name: 'margin',
      desc: '',
      args: [],
    );
  }

  /// `Alert`
  String get alert {
    return Intl.message(
      'Alert',
      name: 'alert',
      desc: '',
      args: [],
    );
  }

  /// `Favs`
  String get favs {
    return Intl.message(
      'Favs',
      name: 'favs',
      desc: '',
      args: [],
    );
  }

  /// `Order Book`
  String get orderBook {
    return Intl.message(
      'Order Book',
      name: 'orderBook',
      desc: '',
      args: [],
    );
  }

  /// `Filled`
  String get filled {
    return Intl.message(
      'Filled',
      name: 'filled',
      desc: '',
      args: [],
    );
  }

  /// `Introduction`
  String get introduction {
    return Intl.message(
      'Introduction',
      name: 'introduction',
      desc: '',
      args: [],
    );
  }

  /// `Main`
  String get mainChart {
    return Intl.message(
      'Main',
      name: 'mainChart',
      desc: '',
      args: [],
    );
  }

  /// `Sub`
  String get subChart {
    return Intl.message(
      'Sub',
      name: 'subChart',
      desc: '',
      args: [],
    );
  }

  /// `BUY`
  String get orderBookBuy {
    return Intl.message(
      'BUY',
      name: 'orderBookBuy',
      desc: '',
      args: [],
    );
  }

  /// `Sell`
  String get orderBookSell {
    return Intl.message(
      'Sell',
      name: 'orderBookSell',
      desc: '',
      args: [],
    );
  }

  /// `Amount`
  String get orderBookAmount {
    return Intl.message(
      'Amount',
      name: 'orderBookAmount',
      desc: '',
      args: [],
    );
  }

  /// `Price`
  String get orderBookPrice {
    return Intl.message(
      'Price',
      name: 'orderBookPrice',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'zh'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
