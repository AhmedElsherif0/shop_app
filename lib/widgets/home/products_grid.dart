import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/widgets/home/product_item.dart';

class ProductsGrid extends StatelessWidget {
  final bool showOnly;

  const ProductsGrid({this.showOnly});

  @override
  Widget build(BuildContext context) {

    final providerData = Provider.of<Products>(context);
    final itemList = showOnly ? providerData.favoriteItem : providerData.items;
    return GridView.builder(
      itemCount: itemList.length,
      padding: const EdgeInsets.all(10),
      itemBuilder: (context, index) => ChangeNotifierProvider.value(
        value: itemList[index],
        child: ProductItem(),
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10),
    );
  }
}
