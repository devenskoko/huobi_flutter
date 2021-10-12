import 'package:get/get.dart';

import 'state.dart';

class IndexLogic extends GetxController {
  final IndexState state = IndexState();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    state.pageController.dispose();
  }

  /// 修改index
  void ChangeIndex(int index) {
    if (state.tabIndex != index) {
      state.tabIndex = index;
      update();
    }
  }
}
