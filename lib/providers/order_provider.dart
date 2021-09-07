import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:shop_app/models/card_model.dart';
import 'package:shop_app/models/order_model.dart';
import 'package:shop_app/utilities/api_query.dart';

class OrderProvider with ChangeNotifier {
  final String token;
  final String userId;
  List<OrderModel> _orderList = [];

  List<OrderModel> get order => [..._orderList];

  OrderProvider(this.token, this.userId, this._orderList);

  Future<void> fetchAndSetOrder() async {
    final url = Uri.parse('$baseAppUrl/order/$userId.json?auth=$token');
    try {
      final response = await http.get(url);
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final List<OrderModel> orderModel = [];
      if (data == null || response.statusCode >= 400) {
        return;
      }
      data.forEach((orderId, orderData) {
        orderModel.add(OrderModel(
            id: orderId,
            amount: orderData['amount'],
            dateTime: DateTime.parse(orderData['datetime']),
            product: (orderData['product'] as List<dynamic>)
                .map((item) => CardModel(
                    id: item['id'],
                    price: item['price'],
                    quantity: item['quantity'],
                    title: item['title']))
                .toList()));
      });
      _orderList = orderModel.reversed.toList();
      notifyListeners();
    } catch (onError) {
      throw (onError.toString());
    }
  }

  Future<void> addOrder(List<CardModel> cardModel, double total) async {
    final url = Uri.parse('$baseAppUrl/order/$userId.json?auth=$token');
    final timestamp = DateTime.now();
    final response = await http.post(url,
        body: jsonEncode({
          'amount': total,
          'datetime': timestamp.toIso8601String(),
          'product': cardModel
              .map((cardProduct) => {
                    'id': cardProduct.id,
                    'title': cardProduct.title,
                    'price': cardProduct.price,
                    'quantity': cardProduct.quantity
                  })
              .toList()
        }));
    _orderList.insert(
        0,
        OrderModel(
            id: jsonDecode(response.body)['name'],
            amount: total,
            dateTime: timestamp,
            // ignore: unnecessary_null_comparison
            product: cardModel));
    notifyListeners();
  }
}
