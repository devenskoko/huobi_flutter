import 'package:get/get.dart';

import 'logic.dart';

class HqDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HqDetailLogic());
  }
}
