
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/card_provider.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screen/card_screen.dart';
import 'package:shop_app/widgets/general/app_drawer.dart';
import 'package:shop_app/widgets/badge.dart';
import 'package:shop_app/widgets/general/custom_circular_progress.dart';
import 'package:shop_app/widgets/home/products_grid.dart';

enum Filter { Selected, All }

class ProductScreen extends StatefulWidget {
  static const routeName = 'product';

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  var _showOnly = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Product'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
        actions: [
          _popUpMenuButton(),
          Consumer<CardProvider>(
            builder: (context, card, ch) => Badge(
              color: card.itemCount == 0
                  ? Colors.transparent
                  : Theme.of(context).colorScheme.secondary,
              child: ch,
              value: card.itemCount != null ? card.itemCount.toString() : '',
            ),
            child: IconButton(
              onPressed: () {
                Navigator.pushNamed(context, CardScreen.routeName);
              },
              icon: const Icon(Icons.shopping_cart),
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future:
            Provider.of<Products>(context, listen: false).fetchAndSetProducts(),
        builder: (context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CustomCircularProgress());
          }
          if (snapshot.error != null) {
            return const Center(child: Text('an Error occurred'));
          }
          return Consumer<Products>(
              builder: (ctx, productsProvider, _) => RefreshIndicator(
                  onRefresh: () => productsProvider.refreshProducts(context),
                  child: ProductsGrid(showOnly: _showOnly)));
        },
      ),
    );
  }

  PopupMenuButton<Filter> _popUpMenuButton() {
    return PopupMenuButton(
      icon: const Icon(Icons.more_vert),
      onSelected: (Filter filter) => setState(() {
        filter == Filter.Selected ? _showOnly = true : _showOnly = false;
      }),
      itemBuilder: (_) => [
        const PopupMenuItem(
            child: Text('Show Favorites'), value: Filter.Selected),
        const PopupMenuItem(child: Text('Show All'), value: Filter.All)
      ],
    );
  }
}
