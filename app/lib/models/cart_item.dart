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
      'menuId': menuItem.id,
      'title': menuItem.title,
      'price': menuItem.price,
      'quantity': quantity,
      'notes': notes,
    };
  }
}
