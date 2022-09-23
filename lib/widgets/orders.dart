import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shopping_app/providers/cart.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_app/widgets/orders_item.dart';

class orderItems {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;
  orderItems(
      {required this.dateTime,
      required this.id,
      required this.products,
      required this.amount});
}

class Orders with ChangeNotifier {
  List<orderItems> _orders = [];
  List<orderItems> get orders {
    return [..._orders];
  }

  Future<void> fetchAndsetOrders() async {
    final Url =
        'https://shoppinapp-f1caf-default-rtdb.firebaseio.com/orders.json';

    final response = await http.get(Uri.parse(Url));
    final List<orderItems> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(orderItems(
        dateTime: DateTime.parse(orderData['dateTime']),
        id: orderId,
        amount: orderData['amount'],
        products: (orderData['products'] as List<dynamic>)
            .map((item) => CartItem(
                id: item['id'],
                title: item['title'],
                price: item['price'],
                quantity: item['quantity']))
            .toList(),
      ));
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final Url =
        'https://shoppinapp-f1caf-default-rtdb.firebaseio.com/orders.json';
    final timeStamp = DateTime.now();
    final response = await http.post(Uri.parse(Url),
        body: json.encode({
          "amount": total,
          "dateTime": timeStamp.toIso8601String(),
          "products": cartProducts
              .map((cp) => {
                    "id": timeStamp.toIso8601String(),
                    "title": cp.title,
                    "price": cp.price,
                    "quantity": cp.quantity
                  })
              .toList(),
        }));
    _orders.insert(
        0,
        orderItems(
          id: json.decode(response.body)['name'],
          amount: total,
          dateTime: timeStamp,
          products: cartProducts,
        ));
    notifyListeners();
  }
}
