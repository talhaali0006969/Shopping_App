//@dart=2.9
import 'dart:convert';
import 'dart:math';
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:shopping_app/models/HttpEcxeption.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _UserId;

  bool get Isauth {
    return _token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return token;
    }
    return null;
  }

  String get UserId {
    return _UserId;
  }

  Future<void> _authanticate(
      String email, String password, String urlSegment) async {
    final Url =
        "https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyAzZS-Y6vj8NBMpdItMpgubkRotg1NY9x8";
    try {
      final Response = await http.post(
        Uri.parse(Url),
        body: json.encode(
          {'email': email, 'password': password, 'returnSecureToken': true},
        ),
      );

      final responseData = json.decode(Response.body);
      if (responseData['error'] != null) {
        throw HttpEcxeption(message: responseData['error']['message']);
      }

      _token = responseData["idToken"];
      _UserId = responseData['localId'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> SignUp(String email, String password) async {
    return _authanticate(email, password, "signUp");
  }

  Future<void> Login(String email, String password) async {
    return _authanticate(email, password, "signInWithPassword");
  }
}
