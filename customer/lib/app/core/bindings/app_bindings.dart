import 'package:customer/app/data/services/cart/cart_service.dart';
import 'package:customer/app/data/services/ledger/ledger_service.dart';
import 'package:customer/app/data/services/orders/order_service.dart';
import 'package:customer/app/data/services/product/product_service.dart';
import 'package:customer/app/data/services/profile/profile_service.dart';
import 'package:get/get.dart';

import '../../data/services/storage/storage_services.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StorageServices>(() => StorageServices(), fenix: true);
    Get.lazyPut<ProductService>(() => ProductService(), fenix: true);
    Get.lazyPut<OrderService>(() => OrderService(), fenix: true);
    Get.lazyPut<ProfileService>(() => ProfileService(), fenix: true);
    Get.lazyPut<LedgerService>(() => LedgerService(), fenix: true);
    Get.lazyPut<CartService>(() => CartService(), fenix: true);
  }
}
