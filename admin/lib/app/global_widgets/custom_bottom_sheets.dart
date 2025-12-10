import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/models/customers/customer_model.dart';

class CustomBottomSheets {
  static void showCustomerDetails(Customer customer) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Get.isDarkMode ? Colors.black : Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (customer.shopPhotoPath != null &&
                customer.shopPhotoPath.toString().isNotEmpty)
              Center(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(customer.shopPhotoPath.toString()),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              )
            else
              Center(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: CircleAvatar(
                    radius: 40,
                    child: Text(
                      customer.shopName?.toString().substring(0, 1).toUpperCase() ??
                          "C",
                      style: const TextStyle(fontSize: 30),
                    ),
                  ),
                ),
              ),
            Text(
              "Customer Details",
              style: Get.textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _buildDetailRow("Shop Name", customer.shopName?.toString() ?? "N/A"),
            _buildDetailRow("Mobile", customer.mobile?.toString() ?? "N/A"),
            _buildDetailRow(
              "Address",
              "${customer.addressLine ?? ''}, ${customer.city ?? ''} - ${customer.pincode ?? ''}",
            ),
            _buildDetailRow(
              "Credit Limit",
              "₹${customer.creditLimit?.toString() ?? '0'}",
            ),
            _buildDetailRow(
              "Status",
              (customer.isApproved == true) ? "Approved" : "Pending",
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  static Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
