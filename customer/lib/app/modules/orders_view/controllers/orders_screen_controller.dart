import 'package:customer/app/data/services/orders/order_service.dart';
import 'package:get/get.dart';
import '../../../data/models/order/order_model.dart'; // Adjust import based on your model location

class OrdersScreenController extends GetxController {
  final OrderService _orderService = Get.find<OrderService>();

  RxList<OrderData> get orders => _orderService.orders;
  bool get isLoading => _orderService.isLoading.value;
  RxBool get isError => _orderService.isError;
  RxString get hasError => _orderService.hasError;

  @override
  void onInit() {
    super.onInit();
    refreshOrders();
  }

  Future<void> refreshOrders() async {
    await _orderService.fetchOrders();
  }
}
