import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:shop_app/providers/auth_provider.dart';
import 'package:shop_app/providers/card_provider.dart';
import 'package:shop_app/providers/order_provider.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/providers/products.dart';

class MultiProviderList {
  static List<SingleChildWidget> _providerList = [
    ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
    ChangeNotifierProxyProvider<AuthProvider, Products>(
        create: (BuildContext context) => Products('', '', []),
        update: (_, auth, previousProduct) => Products(auth.authToken,
            auth.userId, previousProduct == null ? [] : previousProduct.items)),
    ChangeNotifierProvider(create: (_) => Product()),
    ChangeNotifierProvider(create: (_) => CardProvider()),
    ChangeNotifierProxyProvider<AuthProvider, OrderProvider>(
      create: (BuildContext context) => OrderProvider('', '', []),
      update: (_, auth, previousOrder) => OrderProvider(auth.authToken,
          auth.userId, previousOrder == null ? [] : previousOrder.order),
    ),
  ];

  static List<SingleChildWidget> get providerList => _providerList;
}
