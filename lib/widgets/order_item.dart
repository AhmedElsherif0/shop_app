import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop_app/models/order_model.dart';
import 'package:shop_app/widgets/general/customized_text.dart';

class OrderItem extends StatefulWidget {
  final OrderModel orderModel;

  const OrderItem(this.orderModel);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        duration: Duration(milliseconds: 300),
        height: _expanded
            ? min(widget.orderModel.product.length * 20.0 + 110, 220)
            : 95,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Card(
            margin: const EdgeInsets.all(10),
            child: Column(
              children: [
                ListTile(
                  title:
                      Text('\$${widget.orderModel.amount.toStringAsFixed(2)}'),
                  subtitle: Text(
                      '${DateFormat('yy/MM/DD/ hh:mm').format(widget.orderModel.dateTime)}'),
                  trailing: IconButton(
                    icon: _expanded
                        ? const Icon(Icons.chevron_right)
                        : const Icon(Icons.expand_more),
                    onPressed: () {
                      setState(() {
                        _expanded = !_expanded;
                      });
                    },
                  ),
                ),
                if (_expanded)
                  Expanded(
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      margin: EdgeInsets.all(8.0),
                      height: _expanded
                          ? min(
                              widget.orderModel.product.length * 20.0 + 10, 100)
                          : 0,
                      child: ListView(
                        children: widget.orderModel.product
                            .map(
                              (prod) => Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12.0),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        CustomizedText(prod.title.toString()),
                                        Spacer(),
                                        CustomizedText('${prod.quantity} x  '),
                                        CustomizedText(' \$${prod.price}'),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ));
  }
}
