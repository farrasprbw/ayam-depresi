class OrderModel {
  final String id;
  final String userId;
  final List<dynamic> items; // Can be detailed further, storing a map for simplicity
  final num totalAmount;
  final String orderNotes;
  final String deliveryAddress;
  final String status;
  final DateTime createdAt;

  OrderModel({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalAmount,
    this.orderNotes = '',
    this.deliveryAddress = '',
    required this.status,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'items': items,
      'totalAmount': totalAmount,
      'orderNotes': orderNotes,
      'deliveryAddress': deliveryAddress,
      'status': status,
      'createdAt': createdAt,
    };
  }
}
