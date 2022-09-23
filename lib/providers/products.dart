//@dart=2.9
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shopping_app/providers/auth.dart';
import './product.dart';
import 'package:shopping_app/models/HttpEcxeption.dart';
import 'package:shopping_app/providers/products.dart';

class Products with ChangeNotifier {
  List<Product> items = [
    /* Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://martinvalen.com/1333-large_default/men-s-oversized-basic-t-shirt-red.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),*/
  ];
  final String authToken;

  Products(this.authToken, this.items);

  List<Product> get Items {
    return [...items];
  }

  List<Product> get FavItems {
    return items.where((prodItem) => prodItem.isFavorite).toList();
  }

  Product findById(String Id) {
    return Items.firstWhere((prd) => prd.id == Id);
  }

  Future<void> addProduct(Product products) async {
    const Url =
        'https://shoppinapp-f1caf-default-rtdb.firebaseio.com/products.json';
    try {
      final response = await http.post(Uri.parse(Url),
          body: json.encode({
            'title': products.title,
            'description': products.description,
            'imageUrl': products.imageUrl,
            'price': products.price,
            'isFavorite': products.isFavorite
          }));
      final newProduct = Product(
          id: json.decode(response.body)['name'],
          title: products.title,
          imageUrl: products.imageUrl,
          price: products.price,
          description: products.description);
      items.add(newProduct);

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> UpdateProduct(String id, Product newProduct) async {
    final prodIndex = items.indexWhere((prod) => prod.id == id);

    if (prodIndex >= 0) {
      final Url =
          'https://shoppinapp-f1caf-default-rtdb.firebaseio.com/products/$id.json';
      await http.patch(Uri.parse(Url),
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price,
          }));

      items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print("error ......");
    }
  }

  Future<void> deleteproducts(String id) async {
    final Url =
        'https://shoppinapp-f1caf-default-rtdb.firebaseio.com/products/$id.json';
    final existingProductIndex = items.indexWhere((prod) => prod.id == id);
    var existingProduct = items[existingProductIndex];
    items.removeAt(existingProductIndex);
    notifyListeners();

    final response = await http.delete(Uri.parse(Url));
    if (response.statusCode >= 400) {
      items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpEcxeption(message: "Could not Delete Product !");
    }
    existingProduct = null;
  }

  Future<void> fetchAndSetProduct() async {
    final url =
        "https://shoppinapp-f1caf-default-rtdb.firebaseio.com/products.json?auth=$authToken";

    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      final List<Product> loadedProducts = [];
      extractedData.forEach((prodID, prodData) {
        loadedProducts.add(Product(
            id: prodID,
            title: prodData["title"],
            price: prodData["price"],
            description: prodData["description"],
            imageUrl: prodData["imageUrl"]));
      });
      items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
