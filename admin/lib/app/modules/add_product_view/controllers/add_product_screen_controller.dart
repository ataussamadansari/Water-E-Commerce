import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/helpers.dart';
import '../../../data/models/products/product_model.dart';
import '../../../data/repositories/products/products_repository.dart';
import '../../../data/services/product/product_service.dart';

class AddProductController extends GetxController {
  final ProductRepository _productRepo = ProductRepository();
  final ProductService _productService = Get.find<ProductService>();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late TextEditingController nameController,
      skuController,
      descriptionController,
      priceController,
      minOrderQtyController,
      maxOrderQtyController,
      stockQtyController;

  final RxBool isActive = true.obs;
  final RxBool isLoading = false.obs;

  final RxBool isEditMode = false.obs;
  Product? _productToEdit;

  @override
  void onInit() {
    super.onInit();

    nameController = TextEditingController();
    skuController = TextEditingController();
    descriptionController = TextEditingController();
    priceController = TextEditingController();
    minOrderQtyController = TextEditingController();
    maxOrderQtyController = TextEditingController();
    stockQtyController = TextEditingController();

    if (Get.arguments is Product) {
      isEditMode.value = true;
      _productToEdit = Get.arguments;
      _populateFieldsForEdit();
    }
  }

  void _populateFieldsForEdit() {
    final p = _productToEdit!;
    nameController.text = p.name ?? '';
    skuController.text = p.sku ?? '';
    descriptionController.text = p.description ?? '';
    priceController.text = p.price ?? '';
    minOrderQtyController.text = p.minOrderQty?.toString() ?? '0';
    maxOrderQtyController.text = p.maxOrderQty?.toString() ?? '0';
    stockQtyController.text = p.stockQty?.toString() ?? '0';
    isActive.value = p.isActive ?? true;
  }

  Future<void> saveProduct() async {
    if (!formKey.currentState!.validate()) {
      AppHelpers.showSnackBar(
        title: "Invalid Input",
        message: "Please correct the errors.",
        isError: true,
      );
      return;
    }

    isLoading.value = true;

    final productData = {
      'name': nameController.text.trim(),
      'sku': skuController.text.trim(),
      'description': descriptionController.text.trim(),
      'price': priceController.text.trim(),
      'min_order_qty': minOrderQtyController.text.trim(),
      'max_order_qty': maxOrderQtyController.text.trim(),
      'stock_qty': stockQtyController.text.trim(),
      'is_active': isActive.value,
    };

    if (isEditMode.value) {
      // UPDATE PRODUCT
      final response = await _productRepo.updateProduct(_productToEdit!.id!, productData);

      if (response.success) {
        _productService.updateProduct(response.data!);  // LOCAL UPDATE
        Get.back(result: true);
        AppHelpers.showSnackBar(
          title: "Success",
          message: "Product updated successfully!",
          isError: false,
        );
      } else {
        AppHelpers.showSnackBar(
          title: "Error",
          message: response.message,
          isError: true,
        );
      }
    } else {
      // CREATE PRODUCT
      final response = await _productRepo.createProduct(productData);

      if (response.success) {
        _productService.addProduct(response.data!);  // LOCAL UPDATE ❗
        Get.back(result: true);
        AppHelpers.showSnackBar(
          title: "Success",
          message: "Product created successfully!",
          isError: false,
        );
      } else {
        AppHelpers.showSnackBar(
          title: "Error",
          message: response.message,
          isError: true,
        );
      }
    }

    isLoading.value = false;
  }

  String? requiredValidator(String? value) {
    return (value == null || value.trim().isEmpty)
        ? 'This field is required'
        : null;
  }

  @override
  void onClose() {
    nameController.dispose();
    skuController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    minOrderQtyController.dispose();
    maxOrderQtyController.dispose();
    stockQtyController.dispose();
    super.onClose();
  }
}
