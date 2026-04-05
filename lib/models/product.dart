class Product {
  final int id;
  final String name;
  final String description;
  final double price;
  final int iconCodePoint;
  final int colorValue;
  final List<int> availableColors;
  final String imageAsset;
  final String category;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.iconCodePoint,
    required this.colorValue,
    this.availableColors = const [0xFF000000, 0xFF1565C0, 0xFFC62828],
    this.imageAsset = '',
    this.category = '',
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'price': price,
        'iconCodePoint': iconCodePoint,
        'colorValue': colorValue,
        'availableColors': availableColors,
        'imageAsset': imageAsset,
        'category': category,
      };

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'] as int,
        name: json['name'] as String,
        description: json['description'] as String,
        price: (json['price'] as num).toDouble(),
        iconCodePoint: json['iconCodePoint'] as int,
        colorValue: json['colorValue'] as int,
        availableColors: (json['availableColors'] as List).cast<int>(),
        imageAsset: json['imageAsset'] as String? ?? '',
        category: json['category'] as String? ?? '',
      );
}
