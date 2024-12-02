class Gift {
  final int id;
  final int eventId;
  final String name;
  final String description;
  final String category;
  final double price;
  String? imageUrl;
  final String status;

  Gift({
    required this.id,
    required this.eventId,
    required this.name,
    required this.description,
    required this.category,
    required this.price,
    this.imageUrl,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'event_id': eventId,
      'name': name,
      'description': description,
      'category': category,
      'price': price,
      'image_url': imageUrl,
      'status': status,
    };
  }

  factory Gift.fromMap(Map<String, dynamic> map) {
    return Gift(
      id: map['id'],
      eventId: map['event_id'],
      name: map['name'],
      description: map['description'],
      category: map['category'],
      price: map['price'],
      imageUrl: map['image_url'],
      status: map['status'],
    );
  }
}
