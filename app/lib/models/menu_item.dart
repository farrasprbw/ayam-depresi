class MenuItem {
  final String id;
  final String title;
  final String description;
  final num price;
  final int spicyLevel;
  final String? tag;
  final String imageUrl;
  final String category;
  final bool isSoldOut;
  final bool isGrayscale;
  final num? originalPrice;

  MenuItem({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.spicyLevel,
    this.tag,
    required this.imageUrl,
    required this.category,
    this.isSoldOut = false,
    this.isGrayscale = false,
    this.originalPrice,
  });

  factory MenuItem.fromMap(Map<String, dynamic> data, String documentId) {
    return MenuItem(
      id: documentId,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      price: data['price'] ?? 0,
      spicyLevel: data['spicyLevel'] ?? 0,
      tag: data['tag'],
      imageUrl: data['imageUrl'] ?? '',
      category: data['category'] ?? '',
      isSoldOut: data['isSoldOut'] ?? false,
      isGrayscale: data['isGrayscale'] ?? false,
      originalPrice: data['originalPrice'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'price': price,
      'spicyLevel': spicyLevel,
      'tag': tag,
      'imageUrl': imageUrl,
      'category': category,
      'isSoldOut': isSoldOut,
      'isGrayscale': isGrayscale,
      if (originalPrice != null) 'originalPrice': originalPrice,
    };
  }
}
