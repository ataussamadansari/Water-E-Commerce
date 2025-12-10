import 'package:flutter/material.dart';
import 'package:admin/app/data/models/customers/customer_model.dart';
import 'package:admin/app/data/models/products/product_model.dart';
import 'package:admin/app/data/services/customer/customer_service.dart';
import 'package:admin/app/data/services/order/order_service.dart';
import 'package:get/get.dart';
import '../../../data/models/orders/order_model.dart';
import '../../../data/services/product/product_service.dart';
import '../../../routes/app_routes.dart';
import '../../../global_widgets/custom_bottom_sheets.dart';

class DashboardScreenController extends GetxController {
  final ProductService _productService = Get.find<ProductService>();
  final CustomerService _customerService = Get.find<CustomerService>();
  final OrderService _orderService = Get.find<OrderService>();


  // --- API DATA OBSERVABLES ---
  int get totalProducts => _productService.products.length;

  bool get isErrorProduct => _productService.isError.value;
  String get hasErrorProduct => _productService.hasError.value;
  bool get isLoadingProducts => _productService.isLoading.value;

  bool get isErrorCustomer => _customerService.isError.value;
  String get hasErrorCustomer => _customerService.hasError.value;
  bool get isLoadingCustomers => _customerService.isLoading.value;

  bool get isErrorOrders => _orderService.isError.value;
  String get hasErrorOrders => _orderService.hasError.value;
  bool get isLoadingOrders => _orderService.isLoading.value;

  RxList<Product> get products => _productService.products;
  RxList<Customer> get customers => _customerService.customers;
  RxList<Order> get orders => _orderService.orders;

  // --- DYNAMIC STATS OBSERVABLES ---
  int get totalCustomers => _customerService.customers.length;
  int get totalOrders => _orderService.orders.length;
  final RxDouble totalRevenue = 0.0.obs;
  int get pendingOrders => _orderService.pendingOrdersCount;

  @override
  void onInit() {
    super.onInit();
    // Fetch all data when the controller is initialized
    fetchAllData();
  }

  // Helper to fetch all data at once
  Future<void> fetchAllData() async {
    // Run all fetches in parallel for better performance
    await Future.wait([
      // fetchProducts(),
      _productService.fetchProducts(),
      _customerService.fetchCustomers(),
      _orderService.fetchOrders()
    ]);
  }


  // Navigation
  void gotoAddProduct() async {
    // Wait for result so we can refresh the list if a product was added
    final result = await Get.toNamed(Routes.addProduct);
    if (result == true) {
      _productService.fetchProducts();
    }
  }

  void gotoAddRegion() async {
    Get.toNamed(Routes.addRegions);
  }

  void gotoLedger() async {
    Get.toNamed(Routes.ledger);
  }

  void gotoAddUser() async {
    Get.toNamed(Routes.addUser);
  }
  
  void gotoUsers() async {
    Get.toNamed(Routes.users);
  }

  void gotoRegions() async {
    Get.toNamed(Routes.regions);
  }

  void gotoCustomers() async {
    Get.toNamed(Routes.customers);
  }

  void gotoOrders() async {
    Get.toNamed(Routes.orders);
  }

  void gotoProducts() async {
    Get.toNamed(Routes.products);
  }

  void gotoManageStock() async {
    Get.toNamed(Routes.manageStock);
  }

  Future<void> onRefresh() async {
    await fetchAllData();
  }

  void showCustomerDetailsBottomSheet(Customer customer) {
    CustomBottomSheets.showCustomerDetails(customer);
  }
}
