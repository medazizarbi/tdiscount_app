class Product {
  final int id;
  final String name;
  final String price;
  final String? regularPrice;
  final String? description;
  final String? shortDescription;
  final String? imageUrl;
  final bool inStock;

  Product({
    required this.id,
    required this.name,
    required this.price,
    this.regularPrice,
    this.description,
    this.shortDescription,
    this.imageUrl,
    required this.inStock,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    // Extract the first image URL if available
    final imageUrl = (json['images'] as List<dynamic>?)?.isNotEmpty == true
        ? json['images'][0]['src']
        : null;

    return Product(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      regularPrice: json['regular_price'],
      description: json['description'],
      shortDescription: json['short_description'],
      imageUrl: imageUrl,
      inStock: json['stock_status'] == 'instock',
    );
  }
}
