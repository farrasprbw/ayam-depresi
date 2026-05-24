import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/menu_item.dart';

class MenuService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String collectionPath = 'Menus';

  /// Get all menus as a stream
  Stream<List<MenuItem>> getMenus() {
    return _db.collection(collectionPath).snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => MenuItem.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  /// Get menus by category
  Stream<List<MenuItem>> getMenusByCategory(String category) {
    return _db
        .collection(collectionPath)
        .where('category', isEqualTo: category)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => MenuItem.fromMap(doc.data(), doc.id))
              .toList();
        });
  }

  /// Get featured menus (e.g., best sellers)
  Stream<List<MenuItem>> getFeaturedMenus() {
    return _db.collection(collectionPath).limit(3).snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => MenuItem.fromMap(doc.data(), doc.id))
          .toList();
    });
  }
}
