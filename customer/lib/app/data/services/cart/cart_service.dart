import 'package:get/get.dart';
import '../../models/products/product_model.dart';

class CartItem {
  final ProductModel product;
  int qty;

  CartItem({required this.product, this.qty = 1});

  double get subtotal {
    final price = double.tryParse(product.price ?? '0') ?? 0.0;
    return price * qty;
  }
}

class CartService extends GetxService {
  final RxList<CartItem> items = <CartItem>[].obs;

  void addProduct(ProductModel p, {int qty = 1}) {
    final idx = items.indexWhere((it) => it.product.id == p.id);
    if (idx != -1) {
      items[idx].qty += qty;
      items.refresh();
    } else {
      items.insert(0, CartItem(product: p, qty: qty));
    }
  }

  void removeProduct(ProductModel p) {
    items.removeWhere((it) => it.product.id == p.id);
  }

  void updateQty(ProductModel p, int qty) {
    final idx = items.indexWhere((it) => it.product.id == p.id);
    if (idx != -1) {
      items[idx].qty = qty;
      if (items[idx].qty <= 0) items.removeAt(idx);
      items.refresh();
    }
  }

  double get total {
    return items.fold(0.0, (sum, it) => sum + it.subtotal);
  }

  int get totalItems => items.fold(0, (sum, it) => sum + it.qty);

  void clear() => items.clear();
}
