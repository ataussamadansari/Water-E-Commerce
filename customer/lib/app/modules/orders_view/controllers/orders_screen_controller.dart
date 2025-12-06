import 'package:get/get.dart';

import '../../../data/models/order/order_model.dart';
import '../../../data/services/orders/order_service.dart';

class OrdersScreenController extends GetxController
{
  final OrderService _orderService = Get.find<OrderService>();

  // State Variables
  bool get isLoading => _orderService.isLoading.value;
  RxList<OrderData> get orderData => _orderService.orders;

  @override
  void onInit() {
    super.onInit();
    _orderService.fetchOrders();
  }
}
