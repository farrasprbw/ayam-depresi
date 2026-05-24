import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/cart_item.dart';
import '../models/menu_item.dart';
import '../services/cart_service.dart';

class CartProvider extends ChangeNotifier {
  Map<String, CartItem> _items = {};
  String? _userId;
  final CartService _cartService = CartService();

  CartProvider() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      initialize(user?.uid);
    });
  }

  // Call this method when the user logs in or auth state changes
  Future<void> initialize(String? uid) async {
    _userId = uid;
    if (_userId != null) {
      _items = await _cartService.getCart(_userId!);
    } else {
      _items = {};
    }
    notifyListeners();
  }

  void _saveToFirebase() {
    if (_userId != null) {
      _cartService.saveCart(_userId!, _items);
    }
  }

  Map<String, CartItem> get items => {..._items};

  int get itemCount {
    int count = 0;
    _items.forEach((key, item) => count += item.quantity);
    return count;
  }

  num get totalAmount {
    num total = 0;
    _items.forEach((key, cartItem) {
      total += cartItem.totalPrice;
    });
    return total;
  }

  void addItem(MenuItem menuItem, {String notes = ''}) {
    // Generate a unique key for the cart item so that items with different notes/prices are tracked separately
    // Or just use menuItem.id if we don't care about merging items with different notes correctly
    // Wait, if notes/price change, they should ideally be different cart items. Let's just use menuItem.id and append notes hash or just use menuItem.id as is but maybe we should use a composite key if we want to add the same menu item but with different toppings.
    // For simplicity, let's keep it simple: if it's the same item, just update notes or keep existing. If we want separate items, we should change the key. 
    // Let's use a unique key if notes are provided, or append to existing notes?
    // Let's just use menuItem.id + notes as key to separate them if notes are different, otherwise it's fine to just use menuItem.id
    
    String key = '${menuItem.id}_${notes.hashCode}';
    
    if (_items.containsKey(key)) {
      _items.update(
        key,
        (existingItem) => CartItem(
          menuItem: existingItem.menuItem,
          quantity: existingItem.quantity + 1,
          notes: existingItem.notes,
        ),
      );
    } else {
      _items.putIfAbsent(
        key,
        () => CartItem(menuItem: menuItem, notes: notes),
      );
    }
    notifyListeners();
    _saveToFirebase();
  }

  void updateNotes(String itemKey, String notes) {
    if (_items.containsKey(itemKey)) {
      _items.update(
        itemKey,
        (existingItem) => CartItem(
          menuItem: existingItem.menuItem,
          quantity: existingItem.quantity,
          notes: notes,
        ),
      );
      notifyListeners();
      _saveToFirebase();
    }
  }

  void decrementItem(String itemKey) {
    if (!_items.containsKey(itemKey)) return;

    if (_items[itemKey]!.quantity > 1) {
      _items.update(
        itemKey,
        (existingItem) => CartItem(
          menuItem: existingItem.menuItem,
          quantity: existingItem.quantity - 1,
          notes: existingItem.notes,
        ),
      );
    } else {
      _items.remove(itemKey);
    }
    notifyListeners();
    _saveToFirebase();
  }

  void removeItem(String itemKey) {
    _items.remove(itemKey);
    notifyListeners();
    _saveToFirebase();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
    _saveToFirebase();
  }
}
