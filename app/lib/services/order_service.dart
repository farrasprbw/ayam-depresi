import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/order_model.dart';
import '../models/cart_item.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OrderService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String collectionPath = 'Orders';

  Future<String> placeOrder({
    required List<CartItem> cartItems,
    required num totalAmount,
    required String orderNotes,
    required String deliveryAddress,
  }) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User is not logged in.');
    }

    final itemsList = cartItems.map((item) => item.toMap()).toList();

    final docRef = _db.collection(collectionPath).doc();
    final newOrder = OrderModel(
      id: docRef.id,
      userId: user.uid,
      items: itemsList,
      totalAmount: totalAmount,
      orderNotes: orderNotes,
      deliveryAddress: deliveryAddress,
      status: 'PENDING',
      createdAt: DateTime.now(),
    );

    await docRef.set(newOrder.toMap());
    
    // Update user's total order stat
    final userDoc = await _db.collection('Users').doc(user.uid).get();
    if (userDoc.exists) {
      int currentTotal = userDoc.data()?['totalOrder'] ?? 0;
      await _db.collection('Users').doc(user.uid).update({
        'totalOrder': currentTotal + 1,
      });
    }

    return docRef.id;
  }

  /// Get real-time updates for a user's orders
  Stream<List<OrderModel>> getUserOrders() {
    final user = _auth.currentUser;
    if (user == null) return const Stream.empty();

    return _db
        .collection(collectionPath)
        .where('userId', isEqualTo: user.uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return OrderModel(
          id: doc.id,
          userId: data['userId'],
          items: data['items'] ?? [],
          totalAmount: data['totalAmount'] ?? 0,
          orderNotes: data['orderNotes'] ?? '',
          deliveryAddress: data['deliveryAddress'] ?? '',
          status: data['status'] ?? 'UNKNOWN',
          createdAt: (data['createdAt'] as Timestamp).toDate(),
        );
      }).toList();
    });
  }

  /// Get real-time updates for a single order (for live tracking)
  Stream<OrderModel?> getOrderStream(String orderId) {
    return _db.collection(collectionPath).doc(orderId).snapshots().map((snapshot) {
      if (!snapshot.exists || snapshot.data() == null) return null;
      final data = snapshot.data()!;
      return OrderModel(
        id: snapshot.id,
        userId: data['userId'],
        items: data['items'] ?? [],
        totalAmount: data['totalAmount'] ?? 0,
        orderNotes: data['orderNotes'] ?? '',
        deliveryAddress: data['deliveryAddress'] ?? '',
        status: data['status'] ?? 'UNKNOWN',
        createdAt: (data['createdAt'] as Timestamp).toDate(),
      );
    });
  }
}
