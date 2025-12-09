import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/customers/customer_model.dart';
import '../../../data/services/customer/customer_service.dart';
import '../../../routes/app_routes.dart';

class LedgerScreenController extends GetxController {
  final CustomerService _customerService = Get.find<CustomerService>();

  final TextEditingController searchController = TextEditingController();
  final RxList<Customer> filteredCustomers = <Customer>[].obs;

  bool get isLoading => _customerService.isLoading.value;

  @override
  void onInit() {
    super.onInit();
    // Ensure customers are loaded
    if (_customerService.customers.isEmpty) {
      _customerService.fetchCustomers();
    }
    
    // Initial assignment
    filteredCustomers.assignAll(_customerService.customers);

    // Listen to changes
    ever(_customerService.customers, (_) {
      searchCustomers(searchController.text);
    });
  }

  void searchCustomers(String query) {
    if (query.isEmpty) {
      filteredCustomers.assignAll(_customerService.customers);
    } else {
      final lowerQuery = query.toLowerCase();
      filteredCustomers.assignAll(_customerService.customers.where((c) {
        final name = c.shopName?.toLowerCase() ?? ''; // Using shopName as per model
        final mobile = c.mobile?.toString() ?? '';
        return name.contains(lowerQuery) || mobile.contains(lowerQuery);
      }).toList());
    }
  }

  void gotoCustomerLedger(Customer customer) {
    // Navigate to details, passing customer object
    Get.toNamed(Routes.customerLedger, arguments: customer);
  }
  
  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
