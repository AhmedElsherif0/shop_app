import 'package:shop_app/models/card_model.dart';

class OrderModel {

  final String id;
  final double amount;
  final DateTime dateTime;
  final List<CardModel> product;

 const OrderModel({this.id, this.amount,this.product, this.dateTime});

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
        id: json['id'],
        amount: double.parse(json['amount']),
        dateTime: json['dateTime'],
        product: (json['product'] as List<dynamic>)
            .map((order) => CardModel(
                id: order['id'],
                title: order['title'],
                quantity: order['quantity'],
                price: order['price']))
            .toList());
  }
}
