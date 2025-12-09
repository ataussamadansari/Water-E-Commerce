import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controllers/add_product_screen_controller.dart';
import '../../../global_widgets/form_widgets.dart';

class AddProductScreen extends GetView<AddProductController> {
  const AddProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // --- DYNAMIC APPBAR ---
      appBar: AppBar(
        // Use Obx to make the title reactive
        title: Obx(() => Text(
          controller.isEditMode.value ? 'Edit Product' : 'Add New Product',
        )),
        centerTitle: true,
        scrolledUnderElevation: 0,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Image Selection Section ---
              _buildSectionTitle("Product Image"),
              Center(
                child: GestureDetector(
                  onTap: controller.pickImage,
                  child: Obx(() {
                    if (controller.selectedImage.value != null) {
                      return CircleAvatar(
                        radius: 50,
                        backgroundImage: FileImage(
                          File(controller.selectedImage.value!.path),
                        ),
                        backgroundColor: Colors.grey,
                      );
                    } else if (controller.currentImageUrl != null &&
                        controller.currentImageUrl!.isNotEmpty) {
                      return CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(
                          controller.currentImageUrl!,
                        ),
                        backgroundColor: Colors.grey,
                      );
                    } else {
                      return CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey[200],
                        child: const Icon(
                          Icons.camera_alt,
                          size: 40,
                          color: Colors.grey,
                        ),
                      );
                    }
                  }),
                ),
              ),
              const SizedBox(height: 24),

              // --- Basic Information Section ---
              _buildSectionTitle("Basic Information"),

              FormWidgets.buildTextField(
                controller: controller.nameController,
                label: "Product Name",
                icon: Icons.shopping_bag_outlined,
                validator: controller.requiredValidator,
              ),
              const SizedBox(height: 16),

              /*FormWidgets.buildTextField(
                controller: controller.skuController,
                label: "SKU",
                icon: Icons.qr_code,
                validator: controller.requiredValidator,
              ),
              const SizedBox(height: 16),*/

              FormWidgets.buildTextField(
                controller: controller.descriptionController,
                label: "Description",
                icon: Icons.description_outlined,
                validator: controller.requiredValidator,
                keyboardType: TextInputType.multiline,
              ),
              const SizedBox(height: 24),


              // --- Pricing & Stock Section ---
              _buildSectionTitle("Pricing & Stock"),

              FormWidgets.buildTextField(
                controller: controller.priceController,
                label: "Price (₹)",
                icon: Icons.currency_rupee,
                validator: controller.requiredValidator,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: FormWidgets.buildTextField(
                      controller: controller.stockQtyController,
                      label: "Stock Qty",
                      icon: Icons.inventory_2_outlined,
                      validator: controller.requiredValidator,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: FormWidgets.buildTextField(
                      controller: controller.minOrderQtyController,
                      label: "Min Order",
                      icon: Icons.remove_circle_outline,
                      validator: controller.requiredValidator,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              FormWidgets.buildTextField(
                controller: controller.maxOrderQtyController,
                label: "Max Order Qty",
                icon: Icons.add_circle_outline,
                validator: controller.requiredValidator,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              const SizedBox(height: 24),


              // --- Settings Section ---
              _buildSectionTitle("Settings"),

              FormWidgets.buildSwitchField(
                label: "Is Active (Visible to customers)",
                icon: Icons.visibility,
                value: controller.isActive,
              ),
              const SizedBox(height: 32),

              // --- DYNAMIC SUBMIT BUTTON ---
              // Use Obx to make the button reactive
              Obx(() => FormWidgets.buildSubmitButton(
                // Change button text based on the mode
                text: controller.isEditMode.value
                    ? "Update Product"
                    : "Create Product",
                isLoading: controller.isLoading,
                // The saveProduct method already handles both cases
                onPressed: controller.saveProduct,
              )),

              // Extra padding for bottom safe area
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, left: 4.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.grey[700],
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
