import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../controllers/profile_screen_controller.dart';

class ProfileScreen extends GetView<ProfileScreenController> {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile"),
        elevation: 0,
        scrolledUnderElevation: 0,
        actions: [
          Obx(
            () => controller.isEditing.value
                ? IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: controller.toggleEdit,
                  )
                : IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: controller.toggleEdit,
                  ),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading && controller.profileData == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = controller.profileData;
        if (data == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Failed to load profile"),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: controller.refreshProfile,
                  child: const Text("Retry"),
                ),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Header Card
              _buildProfileHeader(data),
              const SizedBox(height: 20),

              // Form / Info Section
              const Text(
                "Shop Details",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _buildInfoCard(context, [
                _buildTextField(
                  "Shop Name",
                  controller.shopNameController,
                  Icons.store,
                  enabled: controller.isEditing.value,
                ),
                _buildTextField(
                  "Mobile Number",
                  controller.mobileController,
                  Icons.phone,
                  enabled: false, // Usually mobile is not editable directly
                ),
              ]),

              const SizedBox(height: 20),
              const Text(
                "Address",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _buildInfoCard(context, [
                _buildTextField(
                  "Address Line",
                  controller.addressController,
                  Icons.location_on,
                  enabled: controller.isEditing.value,
                ),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        "City",
                        controller.cityController,
                        Icons.location_city,
                        enabled: controller.isEditing.value,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildTextField(
                        "State",
                        controller.stateController,
                        Icons.map,
                        enabled: controller.isEditing.value,
                      ),
                    ),
                  ],
                ),
                _buildTextField(
                  "Pincode",
                  controller.pincodeController,
                  Icons.pin_drop,
                  enabled: controller.isEditing.value,
                ),
              ]),

              const SizedBox(height: 30),

              // Save Button (only visible in edit mode)
              if (controller.isEditing.value)
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: controller.isLoading
                        ? null
                        : controller.saveProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: controller.isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "Save Changes",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                  ),
                ),

              const SizedBox(height: 20),

              if (!controller.isEditing.value)
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton.icon(
                    onPressed: controller.logout,
                    icon: const Icon(Icons.logout, color: Colors.red),
                    label: const Text(
                      "Logout",
                      style: TextStyle(color: Colors.red),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 30),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildProfileHeader(dynamic data) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue.shade700,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Stack(
            children: [
              Obx(() {
                // Prioritize selected local image
                if (controller.selectedImage.value != null) {
                  return CircleAvatar(
                    radius: 35,
                    backgroundImage: FileImage(controller.selectedImage.value!),
                  );
                }
                // Fallback to network image if available
                if (data.shopPhotoPath != null &&
                    data.shopPhotoPath.isNotEmpty) {
                  return CircleAvatar(
                    radius: 35,
                    backgroundImage: CachedNetworkImageProvider(
                      data.shopPhotoPath!,
                    ),
                    backgroundColor: Colors.grey,
                  );
                }
                // Fallback to default icon
                return CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    size: 40,
                    color: Colors.blue.shade700,
                  ),
                );
              }),
              if (controller.isEditing.value)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: controller.pickImage,
                    child: CircleAvatar(
                      radius: 12,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.camera_alt,
                        size: 16,
                        color: Colors.blue.shade700,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.shopName ?? "Shop Name",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  data.mobile ?? "",
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 5),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    data.isApproved == true ? "Approved" : "Pending Approval",
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: context.isDarkMode ? Colors.black : Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            // color: Colors.grey.withOpacity(0.1),
            color: Colors.blue.withValues(alpha: 0.25),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    IconData icon, {
    bool enabled = true,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        enabled: enabled,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.blue),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          // filled: !enabled,
          // fillColor: enabled ? Colors.grey : Colors.grey.shade100,
        ),
      ),
    );
  }
}
