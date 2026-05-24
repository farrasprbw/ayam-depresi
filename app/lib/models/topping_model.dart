class Topping {
  final String id;
  final String title;
  final num price;

  Topping({
    required this.id,
    required this.title,
    required this.price,
  });

  factory Topping.fromMap(Map<String, dynamic> data, String documentId) {
    return Topping(
      id: documentId,
      title: data['title'] ?? '',
      price: data['price'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'price': price,
    };
  }
}
