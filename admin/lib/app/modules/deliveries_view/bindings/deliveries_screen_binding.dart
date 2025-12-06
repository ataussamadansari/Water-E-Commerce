import 'package:get/get.dart';

import '../controllers/deliveries_screen_controller.dart';

class DeliveriesScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DeliveriesScreenController>(() => DeliveriesScreenController());
  }
}