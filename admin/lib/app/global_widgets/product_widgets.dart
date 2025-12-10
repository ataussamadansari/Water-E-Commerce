import 'package:flutter/material.dart';
import '../data/models/products/product_model.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final Color bgColor;

  const ProductCard({
    super.key,
    required this.product,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final int stock = int.tryParse(product.stockQty?.toString() ?? "0") ?? 0;

    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 12),
      child: Card(
        color: theme.brightness == Brightness.dark
            ? theme.colorScheme.surfaceVariant
            : bgColor,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15),
                      image: product.imagePath != null &&
                              product.imagePath!.isNotEmpty
                          ? DecorationImage(
                              image: NetworkImage(product.imagePath!),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: (product.imagePath == null ||
                            product.imagePath!.isEmpty)
                        ? const Center(
                            child: Icon(
                              Icons.water_drop,
                              size: 30,
                              color: Colors.blue,
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    product.name ?? "Unknown",
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    product.description ?? "No description",
                    style: theme.textTheme.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "₹${product.price ?? '0'}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.blue,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: stock > 0
                          ? Colors.green.withOpacity(0.1)
                          : Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '$stock left',
                      style: TextStyle(
                        fontSize: 10,
                        color: stock > 0 ? Colors.green : Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
