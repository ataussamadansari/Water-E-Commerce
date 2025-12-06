import 'package:admin/app/data/models/customers/customer_model.dart';
import 'package:admin/app/data/repositories/customers/customers_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../core/utils/helpers.dart';

class CustomerService extends GetxService {
  final CustomersRepository _customerRepo = CustomersRepository();

  // Master List - Single source of truth for customer data
  final RxList<Customer> customers = <Customer>[].obs;

  // Loading State
  final RxBool isLoading = false.obs;
  final RxBool isError = false.obs;
  final RxString hasError = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCustomers();
  }

  //----------------------------------------------
  // FETCH CUSTOMERS (API + LOCAL master state)
  //----------------------------------------------
  Future<void> fetchCustomers() async {
    isLoading.value = true;
    final response = await _customerRepo.getCustomers();

    if (response.success && response.data != null) {
      customers.assignAll(response.data!.data!);
    } else {
      hasError.value = response.message;
      isError.value = true;
    }

    isLoading.value = false;
  }

  // ----------------------------------------------------------------------
  // UPDATE CUSTOMER (API → Local update)
  // ----------------------------------------------------------------------
  Future<bool> updateCustomerFromApi(int id, Map<String, dynamic> data) async {
    final response = await _customerRepo.updateCustomer(id, data);

    if (response.success && response.data != null) {
      updateCustomer(response.data!.data!);
      return true;
    }

    return false;
  }

  // LOCAL update
  void updateCustomer(Customer updatedCustomer) {
    final index = customers.indexWhere((c) => c.id == updatedCustomer.id);
    if (index != -1) {
      customers[index] = updatedCustomer;
      customers.refresh();
    }
  }

  // OPTIONAL: delete support
  void deleteCustomer(int id) {
    customers.removeWhere((c) => c.id == id);
  }

}