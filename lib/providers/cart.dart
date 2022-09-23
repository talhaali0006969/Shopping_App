import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:shopping_app/providers/products.dart';

class CartItem {
  final String id;

  final String title;
  final int quantity;
  final double price;

  CartItem(
      {required this.id,
      required this.title,
      required this.price,
      required this.quantity});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};
  Map<String, CartItem> get items {
    return {..._items};
  }

  int get ItemCount {
    return _items.length;
  }

  double get totalAmount {
    double total = 0;
    _items.forEach((key, CartItem) {
      total += (CartItem.price * CartItem.quantity);
    });
    return total;
  }

  void addItems(String id, double price, String title) {
    if (_items.containsKey(id)) {
      _items.update(
          id,
          (existingCartValue) => CartItem(
              id: existingCartValue.id,
              title: existingCartValue.title,
              price: existingCartValue.price,
              quantity: existingCartValue.quantity + 1));
    } else {
      _items.putIfAbsent(
        id,
        () => CartItem(
            id: DateTime.now.toString(),
            title: title,
            price: price,
            quantity: 1),
      );
    }
    notifyListeners();
  }

  void removeItems(String id) {
    _items.remove(id);
    notifyListeners();
  }

  void removeSingleItem(String id) {
    if (!_items.containsKey(id)) {
      return;
    }
    if (_items[id]!.quantity > 1) {
      _items.update(
          id,
          (existingCartItem) => CartItem(
              id: existingCartItem.id,
              title: existingCartItem.title,
              price: existingCartItem.price,
              quantity: existingCartItem.quantity - 1));
    } else {
      _items.remove(id);
    }
    notifyListeners();
  }

  void Clear() {
    _items = {};
    notifyListeners();
  }
}
