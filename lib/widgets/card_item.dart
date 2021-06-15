import 'package:flutter/material.dart';
import 'package:shop_app/widgets/show_dialog.dart';

class CardItem extends StatelessWidget {
  final String title;
  final double price;
  final String cardId;

  final int quantity;
  final Function onDismissed;
  final String id;

  const CardItem(
      {this.cardId,
      this.title,
      this.price,
      this.quantity,
      this.id,
      this.onDismissed});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Theme.of(context).accentColor,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
      ),
      onDismissed: (direction) {
        onDismissed(cardId);
      },
      confirmDismiss: (direction) async {
        final showDialog = await CustomShowDialog.alertDialog(
          title: 'Are You Sure..',
          message: 'Do You Want To Remove ?',
          context: context,
          buttonNo: () => Navigator.of(context).pop(false),
          buttonYes: () => Navigator.of(context).pop(true),
        );
        return showDialog;
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
            child: ListTile(
              trailing: Text(' $quantity x'),
              leading: FittedBox(
                child: CircleAvatar(minRadius: 40,
                  child: Text('\$${price.toStringAsFixed(2)}'),
                ),
              ),
              title: Text(title),
              subtitle:
                  Text('Total: \$ ${(price * quantity).toStringAsFixed(2)}'),
            ),
          ),
        ),
      ),
    );
  }
}
