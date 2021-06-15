import 'package:flutter/foundation.dart';
import 'package:shop_app/models/card_model.dart';

class CardProvider with ChangeNotifier {
  Map<String, CardModel> _items = {};

  Map<String, CardModel> get items {
    return {..._items};
  }

  int get itemCount => _items.length;

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cardItem) {
      total += cardItem.price * cardItem.quantity;
    });
    return total;
  }

  void addItem(String cardId, String cardTitle, double cardPrice) {
    if (_items.containsKey(cardId)) {
      _items.update(
          cardId,
          (existingItem) =>
              CardModel(
              quantity: existingItem.quantity + 1,
              price: existingItem.price,
              title: existingItem.title,
              id: existingItem.id));
    } else {
      _items.putIfAbsent(
          cardId,
          () => CardModel(
              id: DateTime.now().toString(),
              title: cardTitle,
              price: cardPrice,
              quantity: 1));
    }
    notifyListeners();
  }

  void dismissItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clearCards() {
    _items = {};
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId].quantity > 1) {
      _items.update(
          productId,
          (existingCardItem) => CardModel(
              id: existingCardItem.id,
              price: existingCardItem.price,
              title: existingCardItem.title,
              quantity: existingCardItem.quantity - 1));
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }
}
