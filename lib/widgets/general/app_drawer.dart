import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth_provider.dart';
import 'package:shop_app/screen/auth_screen.dart';
import 'package:shop_app/screen/order_screen.dart';
import 'package:shop_app/screen/product_screen.dart';
import 'package:shop_app/screen/manage_product_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text('Hello Friends'),
            automaticallyImplyLeading: false,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.shop),
            title: const Text('Shop'),
            onTap: () => Navigator.of(context)
                .pushReplacementNamed(ProductScreen.routeName),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.payment),
            title: const Text('Orders'),
            onTap: () => Navigator.of(context)
                .pushReplacementNamed(OrderScreen.routeName),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Manage Product'),
            onTap: () =>
              Navigator.of(context)
                  .pushReplacementNamed(ManageProductScreen.routeName)
            ,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Logout'),
            onTap: () {
              Navigator.pop(context);
              //  Navigator.pushReplacementNamed(context,ProductScreen.routeName);
              Provider.of<AuthProvider>(context, listen: false).logOut();
              Navigator.of(context).pushReplacementNamed(AuthScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
}
