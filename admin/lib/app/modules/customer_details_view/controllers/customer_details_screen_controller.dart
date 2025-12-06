// lib/app/modules/customer_details_view/controllers/customer_details_screen_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/utils/helpers.dart';
import '../../../data/models/customers/customer_model.dart';
import '../../../data/repositories/customers/customers_repository.dart';

class CustomerDetailsScreenController extends GetxController {
  final CustomersRepository _repo = CustomersRepository();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final Rx<Customer?> customer = Rx<Customer?>(null);
  final RxBool isEditing = false.obs;
  final RxBool isLoading = false.obs;

  // Controllers based on your Model
  late TextEditingController shopNameCtrl;
  late TextEditingController mobileCtrl;
  late TextEditingController addressCtrl;
  late TextEditingController cityCtrl;
  late TextEditingController pincodeCtrl;
  late TextEditingController stateCtrl;
  late TextEditingController creditLimitCtrl;

  final RxBool isApproved = false.obs;

  @override
  void onInit() {
    super.onInit();
    shopNameCtrl = TextEditingController();
    mobileCtrl = TextEditingController();
    addressCtrl = TextEditingController();
    cityCtrl = TextEditingController();
    pincodeCtrl = TextEditingController();
    stateCtrl = TextEditingController();
    creditLimitCtrl = TextEditingController();

    if (Get.arguments is Customer) {
      customer.value = Get.arguments as Customer;
      _populateFields();
    }
  }

  void _populateFields() {
    if (customer.value == null) return;
    final c = customer.value!;
    shopNameCtrl.text = c.shopName?.toString() ?? '';
    mobileCtrl.text = c.mobile?.toString() ?? '';
    addressCtrl.text = c.addressLine?.toString() ?? '';
    cityCtrl.text = c.city?.toString() ?? '';
    pincodeCtrl.text = c.pincode?.toString() ?? '';
    stateCtrl.text = c.state?.toString() ?? '';
    creditLimitCtrl.text = c.creditLimit?.toString() ?? '0';
    isApproved.value = c.isApproved ?? false;
  }

  void toggleEdit() {
    if (isEditing.value) {
      // Cancelling edit: revert changes
      _populateFields();
    }
    isEditing.toggle();
  }

  Future<void> updateCustomer() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;

    final Map<String, dynamic> data = {
      "shop_name": shopNameCtrl.text.trim(),
      "mobile": mobileCtrl.text.trim(),
      "address_line": addressCtrl.text.trim(),
      "city": cityCtrl.text.trim(),
      "pincode": pincodeCtrl.text.trim(),
      "state": stateCtrl.text.trim(),
      "credit_limit": creditLimitCtrl.text.trim(),
      "is_approved": isApproved.value,
    };

    final response = await _repo.updateCustomer(customer.value!.id!, data);

    if (response.success == true) {
      // If API returns the full object, use it. Otherwise construct it.
      if (response.data != null) {
        customer.value = response.data!.data!;
      } else {
        debugPrint("📌 Else: ${customer.value!}");
        // Fallback optimistic update
        /*customer.value = customer.value.copyWith(
          shopName: data['shop_name'],
          mobile: data['mobile'],
          addressLine: data['address_line'],
          city: data['city'],
          pincode: data['pincode'],
          creditLimit: data['credit_limit'],
          isApproved: data['is_approved'],
        );*/
      }

      isEditing.value = false;
      Get.back(result: true); // Notify list to refresh
      AppHelpers.showSnackBar(title: "Success", message: "Updated successfully");
    } else {
      AppHelpers.showSnackBar(title: "Error", message: response.message, isError: true);
    }
    isLoading.value = false;
  }

  @override
  void onClose() {
    shopNameCtrl.dispose();
    mobileCtrl.dispose();
    addressCtrl.dispose();
    cityCtrl.dispose();
    pincodeCtrl.dispose();
    stateCtrl.dispose();
    creditLimitCtrl.dispose();
    super.onClose();
  }
}
