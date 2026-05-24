import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';
import '../models/menu_item.dart';

class CartProvider extends ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => {..._items};

  int get itemCount => _items.length;

  num get totalAmount {
    num total = 0;
    _items.forEach((key, cartItem) {
      total += cartItem.totalPrice;
    });
    return total;
  }

  void addItem(MenuItem menuItem) {
    if (_items.containsKey(menuItem.id)) {
      _items.update(
        menuItem.id,
        (existingItem) => CartItem(
          menuItem: existingItem.menuItem,
          quantity: existingItem.quantity + 1,
          notes: existingItem.notes,
        ),
      );
    } else {
      _items.putIfAbsent(
        menuItem.id,
        () => CartItem(menuItem: menuItem),
      );
    }
    notifyListeners();
  }

  void updateNotes(String menuId, String notes) {
    if (_items.containsKey(menuId)) {
      _items.update(
        menuId,
        (existingItem) => CartItem(
          menuItem: existingItem.menuItem,
          quantity: existingItem.quantity,
          notes: notes,
        ),
      );
      notifyListeners();
    }
  }

  void decrementItem(String menuId) {
    if (!_items.containsKey(menuId)) return;

    if (_items[menuId]!.quantity > 1) {
      _items.update(
        menuId,
        (existingItem) => CartItem(
          menuItem: existingItem.menuItem,
          quantity: existingItem.quantity - 1,
          notes: existingItem.notes,
        ),
      );
    } else {
      _items.remove(menuId);
    }
    notifyListeners();
  }

  void removeItem(String menuId) {
    _items.remove(menuId);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
