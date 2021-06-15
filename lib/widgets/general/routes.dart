import 'package:flutter/material.dart';
import 'package:shop_app/screen/auth_screen.dart';
import 'package:shop_app/screen/card_screen.dart';
import 'package:shop_app/screen/edit_product_screen.dart';
import 'package:shop_app/screen/manage_product_screen.dart';
import 'package:shop_app/screen/order_screen.dart';
import 'package:shop_app/screen/product_details.dart';
import 'package:shop_app/screen/product_screen.dart';

class Routes{

 static  Map<String,Widget Function(BuildContext)> _routes =  {
  ProductScreen.routeName: (_) => ProductScreen(),
  ProductDetails.routeName: (_) => ProductDetails(),
  CardScreen.routeName: (_) => CardScreen(),
  OrderScreen.routeName: (_) => OrderScreen(),
  ManageProductScreen.routeName: (_) => ManageProductScreen(),
  EditProductScreen.routeName: (_) => EditProductScreen(),
  AuthScreen.routeName: (_) => AuthScreen()
  };

  Map<String, Function> get routes => _routes;
}