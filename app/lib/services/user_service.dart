import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../models/address_model.dart';

class UserService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Get the current user ID
  String? get currentUserId => _auth.currentUser?.uid;

  /// Stream to listen to current user's profile changes
  Stream<UserModel?> getUserProfileStream() {
    final uid = currentUserId;
    if (uid == null) return Stream.value(null);

    return _db.collection('Users').doc(uid).snapshots().map((snapshot) {
      if (!snapshot.exists || snapshot.data() == null) return null;
      return UserModel.fromMap(snapshot.data()!);
    });
  }

  /// Update user profile
  Future<void> updateUserProfile(Map<String, dynamic> data) async {
    final uid = currentUserId;
    if (uid == null) throw Exception('User not logged in');

    await _db.collection('Users').doc(uid).update(data);
  }

  // --- Address Management ---

  Stream<List<AddressModel>> getUserAddressesStream() {
    final uid = currentUserId;
    if (uid == null) return Stream.value([]);

    return _db
        .collection('Users')
        .doc(uid)
        .collection('Addresses')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => AddressModel.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  Future<void> addAddress(AddressModel address) async {
    final uid = currentUserId;
    if (uid == null) throw Exception('User not logged in');

    final batch = _db.batch();

    // If adding a primary address, unset other primary addresses
    if (address.isPrimary) {
      final querySnapshot = await _db
          .collection('Users')
          .doc(uid)
          .collection('Addresses')
          .where('isPrimary', isEqualTo: true)
          .get();

      for (var doc in querySnapshot.docs) {
        batch.update(doc.reference, {'isPrimary': false});
      }
    }

    final newDoc = _db.collection('Users').doc(uid).collection('Addresses').doc();
    batch.set(newDoc, address.toMap());
    await batch.commit();
  }

  Future<void> setPrimaryAddress(String addressId) async {
    final uid = currentUserId;
    if (uid == null) throw Exception('User not logged in');

    final batch = _db.batch();

    // Unset current primary
    final querySnapshot = await _db
        .collection('Users')
        .doc(uid)
        .collection('Addresses')
        .where('isPrimary', isEqualTo: true)
        .get();

    for (var doc in querySnapshot.docs) {
      batch.update(doc.reference, {'isPrimary': false});
    }

    // Set new primary
    final targetDoc = _db.collection('Users').doc(uid).collection('Addresses').doc(addressId);
    batch.update(targetDoc, {'isPrimary': true});

    await batch.commit();
  }

  Future<void> deleteAddress(String addressId) async {
    final uid = currentUserId;
    if (uid == null) throw Exception('User not logged in');

    await _db
        .collection('Users')
        .doc(uid)
        .collection('Addresses')
        .doc(addressId)
        .delete();
  }
}
