import 'package:get/get.dart';

import '../controllers/add_product_screen_controller.dart';

class AddProductScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddProductController>(() => AddProductController());
  }
}