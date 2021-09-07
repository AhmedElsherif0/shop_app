import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shop_app/utilities/api_query.dart';
import 'package:shop_app/utilities/http_exceptions.dart';
import './product.dart';

class Products with ChangeNotifier {
  List<Product> _item = [];
  final String token;
  final String userId;

  Products(this.token, this.userId, this._item);

  List<Product> get items {
    return [..._item];
  }

  /* void showFavoriteOnly(){
    _showFavorite = true ;
    notifyListeners();
  }
  void showFavoriteAll(){
    _showFavorite = false ;   notifyListeners();
  }*/
  Product findByID(String id) {
    return _item.firstWhere((prod) => prod.productId == id);
  }

  List<Product> get favoriteItem {
    return _item.where((product) => product.isFavorite).toList();
  }

  Future<void> fetchAndSetProducts([bool filterById = false]) async {
    final filterId = filterById ? 'orderBy="userId"&equalTo="$userId"' : '';
    var data = Uri.parse('$baseAppUrl/products.json?auth=$token&$filterId');
    try {
      final response = await http.get(data);
      final extractData = jsonDecode(response.body) as Map<String, dynamic>;
      if (extractData == null) {
        return;
      }
      final url =
          Uri.parse('$baseAppUrl/userFavorite/$userId.json?auth=$token');
      final favoriteResponse = await http.get(url);
      final favoriteData = jsonDecode(favoriteResponse.body);
      final List<Product> loadedProducts = [];
      extractData.forEach((productId, productData) {
        loadedProducts.add(Product(
            productId: productId,
            title: productData["title"],
            description: productData["description"],
            imageUrl: productData["imageUrl"],
            isFavorite:
                favoriteData == null ? false : favoriteData[productId] ?? false,
            price: productData["price"]));
      });
      _item = loadedProducts;
      notifyListeners();
    } catch (onError) {
      print('response Status = ${onError.toString()}');
      throw (onError.toString());
    }
  }

  Future<void> addProducts(Product product) async {
    final url = Uri.parse('$baseAppUrl/products.json?auth=$token');
    try {
      final response = await http.post(url,
          body: jsonEncode({
            'title': product.title,
            'price': product.price,
            'imageUrl': product.imageUrl,
            'description': product.description,
            'userId': userId
          }));
      final newProduct = Product(
        title: product.title,
        price: product.price,
        imageUrl: product.imageUrl,
        description: product.description,
        productId: jsonDecode(response.body)['name'],
      );
      _item.add(newProduct);
      notifyListeners();
    } catch (onError) {
      throw (onError.toString());
    }
  }

  Future<void> refreshProducts(BuildContext context) async {
    await fetchAndSetProducts();
    notifyListeners();
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final productId = _item.indexWhere((product) => product.productId == id);
    if (productId >= 0) {
      try {
        final url = Uri.parse('$baseAppUrl/products/$id.json?auth=$token');
        await http.patch(url,
            body: jsonEncode({
              'title': newProduct.title,
              'price': newProduct.price,
              'imageUrl': newProduct.imageUrl,
              'description': newProduct.description,
            }));
        _item[productId] = newProduct;
        notifyListeners();
      } catch (onError) {
        throw (onError.toString());
      }
    }
  }

  Future<void> deleteProduct(String productId) async {
    final url = Uri.parse('$baseAppUrl/products/$productId.json?auth=$token');
    final existingProductIndex =
        _item.indexWhere((product) => product.productId == productId);
    var existingProduct = _item[existingProductIndex];
    _item.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _item.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpExceptions('Could\'nt Delete Product');
    }
    //_item.removeWhere((product) => product.id == id);
    existingProduct = null;
  }
}
