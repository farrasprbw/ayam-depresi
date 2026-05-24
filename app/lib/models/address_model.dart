class AddressModel {
  final String id;
  final String title;
  final String address;
  final bool isPrimary;

  AddressModel({
    required this.id,
    required this.title,
    required this.address,
    this.isPrimary = false,
  });

  factory AddressModel.fromMap(Map<String, dynamic> data, String docId) {
    return AddressModel(
      id: docId,
      title: data['title'] ?? '',
      address: data['address'] ?? '',
      isPrimary: data['isPrimary'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'address': address,
      'isPrimary': isPrimary,
    };
  }
}
