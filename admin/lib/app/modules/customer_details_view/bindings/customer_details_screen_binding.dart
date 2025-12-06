import 'package:get/get.dart';

import '../controllers/customer_details_screen_controller.dart';

class CustomerDetailsScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CustomerDetailsScreenController>(() => CustomerDetailsScreenController());
  }
}