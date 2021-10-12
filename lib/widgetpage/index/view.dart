import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:huobi_flutter/constants/color_constants.dart';
import 'package:huobi_flutter/manager/status_bar_manager.dart';
import 'package:huobi_flutter/utils/ImageUtil.dart';
import 'package:huobi_flutter/widgets/BottomNavigationBarJerryItem.dart';
import 'package:huobi_flutter/generated/l10n.dart';
import 'logic.dart';

class IndexPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final logic = Get.find<IndexLogic>();
    final state = Get.find<IndexLogic>().state;

    return GetBuilder<IndexLogic>(
      builder: (logic) {
        statusBar(false, systemNavigationBarColor);
        return Scaffold(
          body: PageView.builder(
            // 禁止页面左右滑动
            physics: NeverScrollableScrollPhysics(),
            controller: state.pageController,
            onPageChanged: (int index) => logic.ChangeIndex(index),
            //回调函数
            itemCount: state.pages.length,
            itemBuilder: (context, index) => AnnotatedRegion(child: state.pages[index], value: SystemUiOverlayStyle.dark),
          ),
          bottomNavigationBar: Theme(
            data: ThemeData(
              //去掉水波纹
              highlightColor: Color.fromRGBO(0, 0, 0, 0),
              splashColor: Color.fromRGBO(0, 0, 0, 0),
            ),
            child: BottomNavigationBar(
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: ImageUtil.getAssetsImage("tabbar_home", width: 24, height: 24),
                  activeIcon: BottomNavigationBarJerryItem(
                    imgAsset: 'assets/images/tabbar_home_light.png',
                  ),
                  label: S.of(context).tabbar1,
                ),
                BottomNavigationBarItem(
                  icon: ImageUtil.getAssetsImage("tabbar_markets", width: 24, height: 24),
                  activeIcon: BottomNavigationBarJerryItem(
                    imgAsset: 'assets/images/tabbar_markets_light.png',
                  ),
                  label: S.of(context).tabbar2,
                ),
                BottomNavigationBarItem(
                  icon: ImageUtil.getAssetsImage("tabbar_trade", width: 24, height: 24),
                  activeIcon: BottomNavigationBarJerryItem(
                    imgAsset: 'assets/images/tabbar_trade_light.png',
                  ),
                  label: S.of(context).tabbar3,
                ),
                BottomNavigationBarItem(
                  icon: ImageUtil.getAssetsImage("tabbar_contract", width: 24, height: 24),
                  activeIcon: BottomNavigationBarJerryItem(
                    imgAsset: 'assets/images/tabbar_contract_light.png',
                  ),
                  label: S.of(context).tabbar4,
                ),
                BottomNavigationBarItem(
                  icon: ImageUtil.getAssetsImage("tabbar_banlance", width: 24, height: 24),
                  activeIcon: BottomNavigationBarJerryItem(
                    imgAsset: 'assets/images/tabbar_banlance_light.png',
                  ),
                  label: S.of(context).tabbar5,
                ),
              ],
              currentIndex: state.tabIndex,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: kPrimaryColor,
              selectedFontSize: 12,
              unselectedFontSize: 12,
              unselectedItemColor: kTextColor,
              backgroundColor: Colors.white,
              onTap: (index) {
                state.pageController.jumpToPage(index);
              },
            ),
          ),
        );
      },
    );
  }
}
