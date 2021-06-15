import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screen/edit_product_screen.dart';
import 'package:shop_app/widgets/general/app_drawer.dart';
import 'package:shop_app/widgets/general/custom_circular_progress.dart';
import 'package:shop_app/widgets/user_product_item.dart';

class ManageProductScreen extends StatelessWidget {
  static const routeName = 'user_product_screen';

  Future _refreshFetchingData(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts(true);
    print('refreshed');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Product'),
        actions: [
          IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routeName);
              }),
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshFetchingData(context),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(child: CustomCircularProgress())
                : RefreshIndicator(
                    onRefresh: () => _refreshFetchingData(context),
                    child: Consumer<Products>(
                      builder: (context, products, _) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                          itemCount: products.items.length,
                          itemBuilder: (_, i) => Column(
                            children: [
                              UserProductItem(
                                  id: products.items[i].productId,
                                  title: products.items[i].title,
                                  imageUrl: products.items[i].imageUrl),
                              const Divider()
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
