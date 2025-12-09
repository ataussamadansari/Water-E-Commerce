import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/constants/api_constants.dart';
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

  // Image Picking
  final ImagePicker _picker = ImagePicker();
  final Rx<XFile?> selectedImage = Rx<XFile?>(null);

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
    priceController.text = p.price?.toString() ?? '';
    minOrderQtyController.text = p.minOrderQty?.toString() ?? '0';
    maxOrderQtyController.text = p.maxOrderQty?.toString() ?? '0';
    stockQtyController.text = p.stockQty?.toString() ?? '0';
    isActive.value = p.isActive ?? true;
  }

  Future<void> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        selectedImage.value = image;
      }
    } catch (e) {
      AppHelpers.showSnackBar(
        title: "Image Picker Error",
        message: "Could not pick image: $e",
        isError: true,
      );
    }
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

    // Use FormData to support image upload
    final formData = dio.FormData.fromMap({
      'name': nameController.text.trim(),
      'sku': skuController.text.trim(),
      'description': descriptionController.text.trim(),
      'price': priceController.text.trim(),
      'min_order_qty': minOrderQtyController.text.trim(),
      'max_order_qty': maxOrderQtyController.text.trim(),
      'stock_qty': stockQtyController.text.trim(),
      'is_active': isActive.value ? 1 : 0, // Sending 1 or 0 for boolean usually works better with FormData/backend often
    });

    // Add image if selected
    if (selectedImage.value != null) {
      formData.files.add(MapEntry(
        'image', // The key expected by the backend
        await dio.MultipartFile.fromFile(
          selectedImage.value!.path,
          filename: selectedImage.value!.name,
        ),
      ));
    }

    if (isEditMode.value) {
      // UPDATE PRODUCT
      final response = await _productRepo.updateProduct(_productToEdit!.id!, formData);

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
      final response = await _productRepo.createProduct(formData);

      if (response.success) {
        _productService.addProduct(response.data!);  // LOCAL UPDATE
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

  // Getter for the current image URL (for edit mode)
  String? get currentImageUrl {
    final path = _productToEdit?.imagePath;
    if (path == null || path.isEmpty) return null;
    if (path.startsWith('http')) return path;
    // Assuming ApiConstants.baseUrl is the base for images too
    // If ApiConstants.baseUrl has /api suffix, we might need to adjust, 
    // but usually appending works if path is relative
    
    // Check if baseUrl ends with / and path starts with / to avoid double slash
    String base = ApiConstants.baseUrl;
    if (base.endsWith('/')) {
      base = base.substring(0, base.length - 1);
    }
    String imgPath = path;
    if (!imgPath.startsWith('/')) {
      imgPath = '/$imgPath';
    }
    
    // If Base URL includes /api, and images are in root, this might be wrong.
    // e.g. http://site.com/api/products/img.jpg
    // But we will try this first as it fixes the "No host" error.
    return "$base$imgPath";
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
