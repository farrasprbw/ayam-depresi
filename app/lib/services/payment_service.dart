import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/payment_method_model.dart';

class PaymentService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String collectionPath = 'PaymentMethods';

  Stream<List<PaymentMethodModel>> getPaymentMethodsStream() {
    return _db.collection(collectionPath).where('isActive', isEqualTo: true).snapshots().map((snapshot) {
      if (snapshot.docs.isEmpty) {
        _seedInitialData();
      }
      return snapshot.docs.map((doc) => PaymentMethodModel.fromMap(doc.data(), doc.id)).toList();
    });
  }

  Future<void> _seedInitialData() async {
    final batch = _db.batch();
    
    final cashDoc = _db.collection(collectionPath).doc();
    batch.set(cashDoc, {
      'name': 'CASH KERAS (BAYAR DI TEMPAT)',
      'type': 'cash',
      'isActive': true,
    });

    final qrisDoc = _db.collection(collectionPath).doc();
    batch.set(qrisDoc, {
      'name': 'QRIS (GAK USAH RIBET KEMBALIAN)',
      'type': 'qris',
      'isActive': true,
    });

    await batch.commit();
  }
}
