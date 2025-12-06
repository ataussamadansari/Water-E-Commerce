import 'package:get/get.dart';

import '../controllers/regions_screen_controller.dart';

class RegionsScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RegionsScreenController>(() => RegionsScreenController());
  }
}