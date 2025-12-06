import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../global_widgets/form_widgets.dart';
import '../controllers/add_region_screen_controller.dart';

class AddRegionScreen extends GetView<AddRegionScreenController> {
  const AddRegionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // --- DYNAMIC APPBAR TITLE ---
      appBar: AppBar(
        title: Obx(() => Text(
            controller.isEditMode.value ? "Edit Region" : "Add New Region")),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: controller.formKey,
          child: Column(
            children: [
              FormWidgets.buildTextField(
                controller: controller.nameController,
                label: "Region Name",
                icon: Icons.map,
                validator: controller.requiredValidator,
              ),
              const SizedBox(height: 20),
              FormWidgets.buildTextField(
                controller: controller.cityController,
                label: "City",
                icon: Icons.location_city,
                validator: controller.requiredValidator,
              ),
              const SizedBox(height: 20),
              FormWidgets.buildTextField(
                controller: controller.stateController,
                label: "State",
                icon: Icons.location_on,
                validator: controller.requiredValidator,
              ),
              const SizedBox(height: 20),
              FormWidgets.buildSwitchField(
                label: "Is Active",
                icon: Icons.toggle_on,
                value: controller.isActive,
              ),
              const SizedBox(height: 40),

              // --- DYNAMIC BUTTON ---
              Obx(() => FormWidgets.buildSubmitButton(
                text: controller.isEditMode.value
                    ? "Update Region"
                    : "Create Region",
                onPressed: controller.saveRegion, // Use the combined save method
                isLoading: controller.isLoading,
              )),
            ],
          ),
        ),
      ),
    );
  }
}
