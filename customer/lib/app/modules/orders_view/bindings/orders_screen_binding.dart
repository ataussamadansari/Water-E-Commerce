import 'package:get/get.dart';

import '../controllers/orders_screen_controller.dart';

class OrdersScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrdersScreenController>(() => OrdersScreenController());
  }
}