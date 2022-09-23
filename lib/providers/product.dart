import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  late bool isFavorite;

  Product(
      {required this.id,
      required this.title,
      required this.description,
      required this.price,
      required this.imageUrl,
      this.isFavorite = false});

  void _SetFav(bool newVal) {
    isFavorite = newVal;
    notifyListeners();
  }

  Future<void> toggleFavorite() async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;

    notifyListeners();
    final Url =
        'https://shoppinapp-f1caf-default-rtdb.firebaseio.com/products/$id.json';
    try {
      final response = await http.patch(Uri.parse(Url),
          body: json.encode({
            "isFavorite": isFavorite,
          }));
      if (response.statusCode >= 400) {
        _SetFav(oldStatus);
      }
    } catch (error) {
      _SetFav(oldStatus);
    }
  }
}
