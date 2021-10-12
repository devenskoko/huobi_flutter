import 'package:get/get.dart';

import 'logic.dart';

class IndexBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => IndexLogic(), fenix: true);
  }
}
