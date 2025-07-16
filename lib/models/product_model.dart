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
  final List<int> relatedIds; // NEW: Store related product IDs

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
    required this.relatedIds, // NEW: Required parameter for related IDs
  });

  factory Product.fromJson(Map<String, dynamic> json) {
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
      // NEW: Parse related_ids from JSON
      relatedIds: (json['related_ids'] as List<dynamic>?)
              ?.map((id) => id as int)
              .toList() ??
          [], // Default to empty list if no related products
    );
  }

  // NEW: Helper method to check if product has related products
  bool get hasRelatedProducts => relatedIds.isNotEmpty;

  // NEW: Helper method to get the count of related products
  int get relatedProductsCount => relatedIds.length;
}
