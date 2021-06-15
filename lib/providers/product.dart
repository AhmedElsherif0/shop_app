import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/utilities/constants.dart';

class Product with ChangeNotifier {
  final String productId;
  final String title;
  final String description;
  final double price;
  bool isFavorite;
  final String imageUrl;

  Product(
      {this.productId,
      this.title,
      this.description,
      this.imageUrl,
      this.price,
      this.isFavorite = false});

  void _setFavValue(bool oldStatus) {
    isFavorite = oldStatus;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus(String token, String userId) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url = Uri.parse(
        '$baseAppUrl/userFavorite/$userId/$productId.json?auth=$token');
    try {
      final response = await http.put(url, body: jsonEncode(isFavorite));
      if (response.statusCode >= 400) {
        _setFavValue(oldStatus);
      }
    } catch (error) {
      _setFavValue(oldStatus);
      throw (error.toString());
    }
  }
}
