import 'package:get/get.dart';

import '../controllers/manage_stock_screen_controller.dart';

class ManageStockScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ManageStockScreenController>(() => ManageStockScreenController());
  }
}