import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/order_provider.dart';
import 'package:shop_app/widgets/general/app_drawer.dart';
import 'package:shop_app/widgets/general/custom_circular_progress.dart';
import 'package:shop_app/widgets/order_item.dart';

class OrderScreen extends StatelessWidget {
  static const routeName = 'order_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Your Orders')),
        drawer: AppDrawer(),
        body: FutureBuilder(
            future: Provider.of<OrderProvider>(context, listen: false)
                .fetchAndSetOrder(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CustomCircularProgress());
              }
              if (snapshot.error != null) {
                return const Center(child: Text('an Error occurred'));
              }
              return Consumer<OrderProvider>(
                builder: (context, orderData, child) {
                  return ListView.builder(
                    itemCount: orderData.order.length,
                    itemBuilder: (context, i) => OrderItem(orderData.order[i]),
                  );
                },
              );
            }));
  }
}
