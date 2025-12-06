import 'package:admin/app/data/services/customer/customer_service.dart';
import 'package:admin/app/data/services/product/product_service.dart';
import 'package:get/get.dart';

import '../../data/services/order/order_service.dart';
import '../../data/services/storage/storage_services.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StorageServices>(() => StorageServices(), fenix: true);

    Get.put<ProductService>(ProductService(), permanent: true);
    Get.put<CustomerService>(CustomerService(), permanent: true);
    Get.put<OrderService>(OrderService(), permanent: true);

  }
}