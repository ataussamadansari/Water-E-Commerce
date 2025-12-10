import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../global_widgets/form_widgets.dart';
import '../controllers/customer_details_screen_controller.dart';

class CustomerDetailsScreen extends GetView<CustomerDetailsScreenController> {
  const CustomerDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Customer Details"),
        actions: [
          Obx(() => IconButton(
            icon: Icon(controller.isEditing.value ? Icons.close : Icons.edit),
            onPressed: controller.toggleEdit,
            tooltip: controller.isEditing.value ? "Cancel" : "Edit",
          ))
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.customer.value == null) {
          return const Center(child: Text("No Data"));
        }

        final isEditing = controller.isEditing.value;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: controller.formKey,
            child: Column(
              children: [
                if (controller.customer.value?.shopPhotoPath != null &&
                    controller.customer.value!.shopPhotoPath.toString().isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey[300]!, width: 2),
                      image: DecorationImage(
                        image: NetworkImage(
                            controller.customer.value!.shopPhotoPath.toString()),
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                else
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.blueGrey.withOpacity(0.1),
                      child: Text(
                        controller.customer.value?.shopName
                                ?.toString()
                                .substring(0, 1)
                                .toUpperCase() ??
                            "C",
                        style: const TextStyle(
                            fontSize: 50, color: Colors.blueGrey),
                      ),
                    ),
                  ),
                const SizedBox(height: 20),

                FormWidgets.buildTextField(
                  controller: controller.shopNameCtrl,
                  label: "Shop Name",
                  icon: Icons.storefront,
                  readOnly: !isEditing,
                  validator: (v) => isEditing && (v == null || v.isEmpty) ? "Required" : null,
                ),
                const SizedBox(height: 16),

                // --- UPDATED: Mobile Field is now always ReadOnly ---
                FormWidgets.buildTextField(
                  controller: controller.mobileCtrl,
                  label: "Mobile",
                  icon: Icons.phone,
                  keyboardType: TextInputType.phone,
                  readOnly: true, // <--- Changed from !isEditing to true
                  // validation removed as it's read-only
                ),

                const Divider(height: 30),

                FormWidgets.buildTextField(
                  controller: controller.addressCtrl,
                  label: "Address",
                  icon: Icons.location_on,
                  readOnly: !isEditing,
                  validator: (v) => isEditing && (v == null || v.isEmpty) ? "Required" : null,
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: FormWidgets.buildTextField(
                        controller: controller.cityCtrl,
                        label: "City",
                        icon: Icons.location_city,
                        readOnly: !isEditing,
                        validator: (v) => isEditing && (v == null || v.isEmpty) ? "Required" : null,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: FormWidgets.buildTextField(
                        controller: controller.pincodeCtrl,
                        label: "Pincode",
                        icon: Icons.pin_drop,
                        keyboardType: TextInputType.number,
                        readOnly: !isEditing,
                        validator: (v) => isEditing && (v == null || v.isEmpty) ? "Required" : null,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                FormWidgets.buildTextField(
                  controller: controller.stateCtrl,
                  label: "State",
                  icon: Icons.location_on,
                  readOnly: !isEditing,
                  validator: (v) => isEditing && (v == null || v.isEmpty) ? "Required" : null,
                ),

                const Divider(height: 30),

                FormWidgets.buildTextField(
                  controller: controller.creditLimitCtrl,
                  label: "Credit Limit",
                  icon: Icons.attach_money,
                  keyboardType: TextInputType.number,
                  readOnly: !isEditing,
                  validator: (v) => isEditing && (v == null || v.isEmpty) ? "Required" : null,
                ),
                const SizedBox(height: 16),

                // Switch for Approval
                FormWidgets.buildSwitchField(
                  label: "Is Approved?",
                  value: controller.isApproved,
                  icon: Icons.verified_user,
                  isEditable: isEditing,
                ),

                const SizedBox(height: 30),

                if (isEditing)
                  FormWidgets.buildSubmitButton(
                    text: "Save Changes",
                    onPressed: controller.updateCustomer,
                    isLoading: controller.isLoading,
                  ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
