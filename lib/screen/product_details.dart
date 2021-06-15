import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';

class ProductDetails extends StatelessWidget {
  static const routeName = 'product_details';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    final loadedProduct = Provider.of<Products>(context).findByID(productId);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(loadedProduct.title),
              background: Hero(
                  tag: loadedProduct.productId,
                  child: FadeInImage(
                    placeholder: AssetImage('assets/product-placeholder.png'),
                    image: NetworkImage(loadedProduct.imageUrl),
                    fit: BoxFit.cover,
                  )),
            ),
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            const SizedBox(
              height: 10.0,
            ),
            Text(
              '\$${loadedProduct.price.toStringAsFixed(2)}',
              style: const TextStyle( fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                loadedProduct.description,
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ),
            Column(
              children: [
                Container(
                    height: 900, width: double.infinity, child: Text('hello',                textAlign: TextAlign.center,
                )),
              ],
            ),
          ])),
        ],
      ),
    );
  }
}
