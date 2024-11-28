class OldGift {
  final String name;
  final String category;
  final String status; // either pledged or available
  final String? description;
  final double? price;
  final String? imageUrl;

  OldGift({
    required this.name,
    required this.category,
    required this.status,
    this.description,
    this.price,
    this.imageUrl,
  });

  OldGift copyWith({
    String? name,
    String? category,
    String? status,
    String? description,
    double? price,
    String? imageUrl,
  }) {
    return OldGift(
      name: name ?? this.name,
      category: category ?? this.category,
      status: status ?? this.status,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
