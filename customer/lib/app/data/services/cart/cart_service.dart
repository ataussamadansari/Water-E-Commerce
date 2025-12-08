import 'package:customer/app/core/utils/helpers.dart';
import 'package:get/get.dart';
import '../../models/cart/carts_response.dart';
import '../../repositories/cart/cart_repository.dart';

class CartService extends GetxService {
  final CartRepository _repo = CartRepository();

  final Rx<Data?> cart = Rx<Data?>(null);

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCart();
  }

  // ---------------------------------------------------------
  // COMMON HANDLER FOR ERROR
  // ---------------------------------------------------------
  void _handleError(String? msg) {
    errorMessage.value = msg ?? "Unknown error";
    AppHelpers.showSnackBar(
      title: "Cart Error",
      message: errorMessage.value,
      isError: true,
    );
  }

  // ---------------------------------------------------------
  // FETCH CART (GET)
  // ---------------------------------------------------------
  Future<void> fetchCart() async {
    isLoading.value = true;

    final response = await _repo.getCart();

    if (response.success && response.data != null) {
      cart.value = response.data!.data;
    } else {
      // Don't show error snackbar on fetch if it's just empty or initial load failure
      // _handleError(response.message);
    }

    isLoading.value = false;
  }

  // ---------------------------------------------------------
  // ADD TO CART
  // ---------------------------------------------------------
  Future<bool> addToCart(int productId, int qty) async {
    isLoading.value = true;

    final response = await _repo.addToCart({
      "product_id": productId,
      "qty": qty,
    });

    isLoading.value = false;

    if (response.success && response.data != null) {
      await fetchCart();

      AppHelpers.showSnackBar(
        title: "Added to Cart",
        message: "Product added successfully",
        isError: false,
      );

      return true;
    } else {
      _handleError(response.message);
      return false;
    }
  }

  // ---------------------------------------------------------
  // REMOVE FROM CART
  // ---------------------------------------------------------
  Future<bool> removeFromCart(int cartItemId) async {
    isLoading.value = true;

    // Use cartItemId directly as it is required by the endpoint /customer/cart/{cartItem}/delete
    final response = await _repo.removeFromCart(cartItemId);

    isLoading.value = false;

    if (response.success) {
      await fetchCart();

      AppHelpers.showSnackBar(
        title: "Item Removed",
        message: "Product removed from cart",
      );

      return true;
    } else {
      _handleError(response.message);
      return false;
    }
  }

  // ---------------------------------------------------------
  // CLEAR CART
  // ---------------------------------------------------------
  Future<bool> clearCart() async {
    isLoading.value = true;

    final response = await _repo.clearCart();

    isLoading.value = false;

    if (response.success) {
      cart.value = null; // Or empty object
      await fetchCart(); // To be sure

      AppHelpers.showSnackBar(
        title: "Cart Cleared",
        message: "All items removed from cart",
      );

      return true;
    } else {
      _handleError(response.message);
      return false;
    }
  }

  // ---------------------------------------------------------
  // CHECKOUT
  // ---------------------------------------------------------
  Future<bool> checkout(Map<String, dynamic> data) async {
    isLoading.value = true;

    final response = await _repo.checkout(data);

    isLoading.value = false;

    if (response.success) {
      cart.value = null; // Clear local cart

      AppHelpers.showSnackBar(
        title: "Order Placed",
        message: "Your checkout was successful",
        isError: false,
      );

      return true;
    } else {
      _handleError(response.message);
      return false;
    }
  }
}
