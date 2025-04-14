class Product {
  final int id;
  final String name;
  final String price;
  final String imageUrl;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      price: json['price'].toString(),
      imageUrl: json['images'].isNotEmpty ? json['images'][0]['src'] : '',
    );
  }

  get discount => null;
}
