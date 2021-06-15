import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth_provider.dart';
import 'package:shop_app/providers/card_provider.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/screen/product_details.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);
    final cart = Provider.of<CardProvider>(context);
    final theme = Theme.of(context);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: GridTile(
        child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(ProductDetails.routeName,
                  arguments: product.productId);
            },
            child: Hero(
              tag: product.productId,
              child: FadeInImage(
                placeholder: AssetImage('assets/product-placeholder.png'),
                image: product.imageUrl.isNotEmpty
                    ? (NetworkImage(product.imageUrl) ?? null)
                    : AssetImage('assets/product-placeholder.png'),
                fit: BoxFit.cover,
              ),
            )),
        footer: GridTileBar(
          backgroundColor: Colors.black38,
          title: Text(product.title, style: theme.textTheme.headline6),
          leading: Consumer<Product>(
            builder: (context, provider, _) => IconButton(
              icon: Icon(
                  provider.isFavorite ? Icons.favorite : Icons.favorite_border),
              color: theme.accentColor,
              onPressed: () async => await provider.toggleFavoriteStatus(
                  authProvider.authToken, authProvider.userId),
            ),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.add_shopping_cart),
            color: theme.accentColor,
            onPressed: () async {
              try {
                cart.addItem(product.productId, product.title, product.price);
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: const Text(
                    'Added Item to The Card',
                    textAlign: TextAlign.center,
                  ),
                  duration: const Duration(seconds: 2),
                  action: SnackBarAction(
                      label: 'Undo',
                      onPressed: () {
                        cart.removeSingleItem(product.productId);
                      }),
                ));
              } catch (error) {
                print(error.toString());
              }
            },
          ),
        ),
      ),
    );
  }
}
