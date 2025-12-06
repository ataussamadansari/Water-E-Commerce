import 'package:get/get.dart';

import '../controllers/add_region_screen_controller.dart';

class AddRegionScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddRegionScreenController>(() => AddRegionScreenController());
  }
}