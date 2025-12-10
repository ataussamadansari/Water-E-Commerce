import 'package:flutter/material.dart';
import '../data/models/customers/customer_model.dart';

class CustomerListTile extends StatelessWidget {
  final Customer customer;
  final VoidCallback? onEyeTap;

  const CustomerListTile({
    super.key,
    required this.customer,
    this.onEyeTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final String initial = (customer.shopName?.isNotEmpty == true)
        ? customer.shopName![0].toUpperCase()
        : 'C';

    final addressParts = [
      customer.addressLine,
      customer.city,
      customer.state,
      customer.pincode,
    ].where((part) => part != null && part.isNotEmpty).toList();
    final String fullAddress = addressParts.join(', ');

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: theme.dividerColor, width: 1),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundImage: (customer.shopPhotoPath != null &&
                    customer.shopPhotoPath.toString().isNotEmpty)
                ? NetworkImage(customer.shopPhotoPath.toString())
                : null,
            backgroundColor: Colors.blue.withOpacity(0.1),
            child: (customer.shopPhotoPath == null ||
                    customer.shopPhotoPath.toString().isEmpty)
                ? Text(
                    initial,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  customer.shopName ?? "Unknown Shop",
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                if (fullAddress.isNotEmpty)
                  Text(
                    fullAddress,
                    style: theme.textTheme.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          if (onEyeTap != null)
            IconButton(
              onPressed: onEyeTap,
              icon: const Icon(Icons.remove_red_eye, color: Colors.blue),
            ),
        ],
      ),
    );
  }
}
