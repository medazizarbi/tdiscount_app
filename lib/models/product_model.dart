class Product {
  final int id;
  final String name;
  final String price;
  final String? regularPrice;
  final String? description;
  final String? shortDescription;
  final List<String> imageUrls; // Store all image URLs
  final bool inStock;
  final String? sku;

  Product({
    required this.id,
    required this.name,
    required this.price,
    this.regularPrice,
    this.description,
    this.shortDescription,
    required this.imageUrls,
    required this.inStock,
    this.sku,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    // Extract the first image URL if available

    return Product(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      regularPrice: json['regular_price'],
      description: json['description'],
      shortDescription: json['short_description'],
      imageUrls: (json['images'] as List<dynamic>?)
              ?.map((img) => img['src'] as String)
              .toList() ??
          [],
      inStock: json['stock_status'] == 'instock',
      sku: json['sku'] as String?,
    );
  }
}
