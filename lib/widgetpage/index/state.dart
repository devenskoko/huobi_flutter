import 'package:flutter/cupertino.dart';
import 'package:huobi_flutter/widgetpage/home/view.dart';


class IndexState {
  late List<Widget> pages;

  late int tabIndex;

  late PageController pageController;

  IndexState() {
    tabIndex = 0;
    pages = [
      HomePage(),
      Container(),
      Container(),
      Container(),
      Container(),
    ];
    pageController = PageController();
  }
}
