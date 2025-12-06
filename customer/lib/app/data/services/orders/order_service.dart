import 'package:customer/app/data/models/order/order_model.dart';
import 'package:get/get.dart';
import '../../models/order/order_place_response.dart';
import '../../models/order/single_order_response.dart';
import '../../repositories/orders/order_repository.dart';

class OrderService extends GetxService {
  final OrderRepository _repo = OrderRepository();

  /// Overall Order List
  final RxList<OrderData> orders = <OrderData>[].obs;

  /// Loading & Error
  final RxBool isLoading = false.obs;
  final RxBool isError = false.obs;
  final RxString hasError = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrders(); // Load orders on startup
  }

  // ----------------------------------------------------------------------
  // PLACE ORDER (POST)
  // ----------------------------------------------------------------------
  Future<OrderPlaceResponse?> placeOrder(Map<String, dynamic> data) async {
    final response = await _repo.orderPlace(data);

    if (response.success && response.data != null) {
      // Newly placed order should appear in user's order list immediately
      if (response.data?.data != null) {
        orders.insert(0, response.data!.data!);
      }
      return response.data!;
    } else {
      hasError.value = response.message;
      isError.value = true;
      return null;
    }
  }

  // ----------------------------------------------------------------------
  // GET ALL ORDERS
  // ----------------------------------------------------------------------
  Future<void> fetchOrders() async {
    isLoading.value = true;
    isError.value = false;
    hasError.value = "";

    final response = await _repo.getOrders();

    if (response.success && response.data != null) {
      orders.assignAll(response.data!.data ?? []);
    } else {
      isError.value = true;
      hasError.value = response.message;
    }

    isLoading.value = false;
  }

  // ----------------------------------------------------------------------
  // GET SINGLE ORDER
  // ----------------------------------------------------------------------
  Future<SingleOrderResponse?> getOrderById(int id) async {
    final response = await _repo.getOrderById(id);

    if (response.success && response.data != null) {
      return response.data!;
    }

    hasError.value = response.message;
    isError.value = true;
    return null;
  }

  // ----------------------------------------------------------------------
  // OPTIONAL: Local Update / Insert Helpers
  // ----------------------------------------------------------------------
  void updateOrderLocal(OrderData updated) {
    final index = orders.indexWhere((o) => o.id == updated.id);
    if (index != -1) {
      orders[index] = updated;
      orders.refresh();
    }
  }

  void addOrderLocal(OrderData order) {
    orders.insert(0, order);
  }
}
