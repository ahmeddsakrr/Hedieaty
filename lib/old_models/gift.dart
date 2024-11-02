class Gift {
  final String name;
  final String category;
  final String status; // either pledged or available
  final String? description;
  final double? price;
  final String? imageUrl;

  Gift({
    required this.name,
    required this.category,
    required this.status,
    this.description,
    this.price,
    this.imageUrl,
  });

  Gift copyWith({
    String? name,
    String? category,
    String? status,
    String? description,
    double? price,
    String? imageUrl,
  }) {
    return Gift(
      name: name ?? this.name,
      category: category ?? this.category,
      status: status ?? this.status,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
