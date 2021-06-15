import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/card_provider.dart';
import 'package:shop_app/providers/order_provider.dart';
import 'package:shop_app/widgets/card_item.dart';
import 'package:shop_app/widgets/general/custom_circular_progress.dart';

class CardScreen extends StatefulWidget {
  static const routeName = '/card-screen';

  @override
  _CardScreenState createState() => _CardScreenState();
}

class _CardScreenState extends State<CardScreen> {
  @override
  Widget build(BuildContext context) {
    final card = Provider.of<CardProvider>(context);
    final cardToList = card.items.values.toList();
    final cardId = card.items.keys.toList();
    var _isLoading = false;

    return Scaffold(
      appBar: AppBar(
        title: const Text('CardScreen'),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    const Text(
                      'Total',
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                    const Spacer(),
                    Chip(
                      label: Text('\$ ${card.totalAmount.toStringAsFixed(2)}'),
                    ),
                    Consumer<OrderProvider>(
                      builder: (context, order, ch) => TextButton(
                        onPressed: (_isLoading || card.totalAmount <= 0) ? null
                            : () async {
                                setState(() {_isLoading = true;
                                });
                                await order.addOrder(card.items.values.toList(),
                                    card.totalAmount);
                                card.clearCards();
                                setState(() {
                                  _isLoading = false;
                                });
                              },
                        child: _isLoading
                            ? const  CustomCircularProgress()
                            : const Text('Order Now'),
                      ),
                    ),
                  ],
                )),
          ),
          const SizedBox(
            height: 10.0,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: card.items.length,
              itemBuilder: (context, i) => CardItem(
                cardId: cardId[i],
                title: cardToList[i].title,
                id: cardToList[i].id,
                price: cardToList[i].price,
                quantity: cardToList[i].quantity,
                onDismissed: (direction) {
                  card.dismissItem(cardId[i]);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
