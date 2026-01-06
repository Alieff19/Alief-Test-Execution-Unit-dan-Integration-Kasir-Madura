import 'package:flutter/foundation.dart';
import '../data/models/product.dart';

class CartItem {
  final Product product;
  int qty;

  CartItem({required this.product, this.qty = 1});
}

class CartController extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  // CART KOSONG?
  bool get isEmpty => _items.isEmpty;

  // JUMLAH TOTAL ITEM DI CART
  int get cartCount {
    int total = 0;
    for (var item in _items) {
      total += item.qty;
    }
    return total;
  }

  // ADD TO CART
  void addToCart(Product product) {
    final index = _items.indexWhere((item) => item.product.id == product.id);

    if (index == -1) {
      _items.add(CartItem(product: product));
    } else {
      _items[index].qty++;
    }

    notifyListeners();
  }

  // REMOVE 1 ITEM
  void removeFromCart(Product product) {
    final index = _items.indexWhere((item) => item.product.id == product.id);

    if (index != -1) {
      if (_items[index].qty > 1) {
        _items[index].qty--;
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  // CLEAR CART
  void clear() {
    _items.clear();
    notifyListeners();
  }

  // TOTAL HARGA
  double get totalHarga {
    double total = 0;
    for (var item in _items) {
      total += item.product.hargaJual * item.qty;
    }
    return total;
  }
}
