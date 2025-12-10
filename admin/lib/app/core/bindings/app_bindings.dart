import 'package:admin/app/data/services/customer/customer_service.dart';
import 'package:admin/app/data/services/product/product_service.dart';
import 'package:admin/app/data/services/user/user_service.dart';
import 'package:admin/app/data/services/firebase_messaging_service.dart';
import 'package:get/get.dart';

import '../../data/services/order/order_service.dart';
import '../../data/services/storage/storage_services.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StorageServices>(() => StorageServices(), fenix: true);

    Get.lazyPut<ProductService>(() => ProductService(), fenix: true);
    Get.lazyPut<CustomerService>(() => CustomerService(), fenix: true);
    Get.lazyPut<OrderService>(() => OrderService(), fenix: true);
    Get.lazyPut<UserService>(() => UserService(), fenix: true);

    Get.putAsync<FirebaseMessagingService>(() => FirebaseMessagingService().init());
  }
}
