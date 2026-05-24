import 'menu_item.dart';

class CartItem {
  final MenuItem menuItem;
  int quantity;
  String notes;

  CartItem({
    required this.menuItem,
    this.quantity = 1,
    this.notes = '',
  });

  num get totalPrice => menuItem.price * quantity;

  Map<String, dynamic> toMap() {
    return {
      'menuItem': menuItem.toMap(),
      'menuId': menuItem.id, // Stored to reconstruct MenuItem using fromMap
      'quantity': quantity,
      'notes': notes,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      menuItem: MenuItem.fromMap(map['menuItem'], map['menuId']),
      quantity: map['quantity'] ?? 1,
      notes: map['notes'] ?? '',
    );
  }
}
