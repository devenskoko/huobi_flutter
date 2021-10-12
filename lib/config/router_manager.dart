import 'package:get/get.dart';
import 'package:huobi_flutter/widgetpage/hq_detail/binding.dart';
import 'package:huobi_flutter/widgetpage/hq_detail/view.dart';
import 'package:huobi_flutter/widgetpage/index/binding.dart';
import 'package:huobi_flutter/widgetpage/index/view.dart';
import 'package:huobi_flutter/widgetpage/splash/binding.dart';
import 'package:huobi_flutter/widgetpage/splash/view.dart';
class RouteConfig {
  static const String splash = "/splash";
  static const String index = "/index";
  static const String hqDetail = "/hqDetail";

  static final List<GetPage> getPages = [
    GetPage(
      name: splash,
      page: () => SplashPage(),
      binding: SplashBinding(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: index,
      page: () => IndexPage(),
      binding: IndexBinding(),
      transitionDuration: Duration(milliseconds: 1),
    ),
    GetPage(
      name: hqDetail,
      page: () => HqDetailPage(),
      binding: HqDetailBinding(),
    ),
  ];
}