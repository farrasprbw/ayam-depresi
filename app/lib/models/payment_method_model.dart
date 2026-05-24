class PaymentMethodModel {
  final String id;
  final String name;
  final String type;
  final bool isActive;

  PaymentMethodModel({
    required this.id,
    required this.name,
    required this.type,
    this.isActive = true,
  });

  factory PaymentMethodModel.fromMap(Map<String, dynamic> data, String docId) {
    return PaymentMethodModel(
      id: docId,
      name: data['name'] ?? '',
      type: data['type'] ?? '',
      isActive: data['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'type': type,
      'isActive': isActive,
    };
  }
}
