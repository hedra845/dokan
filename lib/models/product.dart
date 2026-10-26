class ProductAddon {
  final String id;
  final String name;
  final double price;

  const ProductAddon({required this.id, required this.name, required this.price});
}

class Product {
  final String id;
  final String restaurantId;
  final String categoryId;
  final String category;
  final String name;
  final String description;
  final double price;
  final String? imageUrl;
  final bool isAvailable;
  final List<ProductAddon> addons;

  const Product({
    required this.id,
    required this.restaurantId,
    required this.categoryId,
    required this.category,
    required this.name,
    required this.description,
    required this.price,
    this.imageUrl,
    this.isAvailable = true,
    this.addons = const [],
  });

  Product copyWith({bool? isAvailable}) {
    return Product(
      id: id,
      restaurantId: restaurantId,
      categoryId: categoryId,
      category: category,
      name: name,
      description: description,
      price: price,
      imageUrl: imageUrl,
      isAvailable: isAvailable ?? this.isAvailable,
      addons: addons,
    );
  }
}
