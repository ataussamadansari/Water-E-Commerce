import 'package:get/get.dart';

import '../controllers/products_screen_controller.dart';

class ProductsScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProductsScreenController>(() => ProductsScreenController());
  }
}