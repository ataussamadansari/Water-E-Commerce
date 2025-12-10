import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class FormWidgets {
  // A reusable text input field
  static Widget buildTextField({
    required TextEditingController controller,
    required String label,
    IconData? icon,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    bool readOnly = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      textCapitalization: TextCapitalization.sentences,
      readOnly: readOnly,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon != null ? Icon(icon) : null,
        // If readOnly, remove borders or make them invisible to look like plain text
        border: readOnly
            ? InputBorder.none
            : OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
        enabledBorder: readOnly
            ? InputBorder.none
            : OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
        focusedBorder: readOnly
            ? InputBorder.none
            : OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Get.theme.primaryColor),
              ),
        filled: !readOnly,
        contentPadding: readOnly ? const EdgeInsets.all(0) : null,
      ),
      validator: validator,
    );
  }

  // A reusable switch for boolean values
  static Widget buildSwitchField({
    required String label,
    required RxBool value,
    required IconData icon,
    bool isEditable = true,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[600]),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
          Obx(
            () => Switch(
              value: value.value,
              onChanged: isEditable ? (newValue) => value.value = newValue : null,
            ),
          ),
        ],
      ),
    );
  }

  // A reusable submit button
  static Widget buildSubmitButton({
    required String text,
    required VoidCallback onPressed,
    required RxBool isLoading,
  }) {
    return Obx(
      () => SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: isLoading.value ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Get.theme.primaryColor,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: isLoading.value
              ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(color: Colors.white),
                )
              : Text(
                  text,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
        ),
      ),
    );
  }
}
