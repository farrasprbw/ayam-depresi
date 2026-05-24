import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/cart_item.dart';

class CartService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveCart(String userId, Map<String, CartItem> items) async {
    try {
      final Map<String, dynamic> cartData = {};
      items.forEach((key, item) {
        cartData[key] = item.toMap();
      });

      await _firestore.collection('carts').doc(userId).set({
        'items': cartData,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('Error saving cart to Firebase: $e');
    }
  }

  Future<Map<String, CartItem>> getCart(String userId) async {
    try {
      final doc = await _firestore.collection('carts').doc(userId).get();
      if (doc.exists && doc.data() != null) {
        final Map<String, dynamic> data = doc.data()!;
        final Map<String, dynamic>? itemsData = data['items'] as Map<String, dynamic>?;

        if (itemsData != null) {
          final Map<String, CartItem> cartItems = {};
          itemsData.forEach((key, itemData) {
            cartItems[key] = CartItem.fromMap(itemData as Map<String, dynamic>);
          });
          return cartItems;
        }
      }
    } catch (e) {
      debugPrint('Error fetching cart from Firebase: $e');
    }
    return {};
  }
}
