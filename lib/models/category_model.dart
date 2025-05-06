class Category {
  final int id;
  final String name;
  final int count;
  final String? description;

  Category({
    required this.id,
    required this.name,
    required this.count,
    this.description,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      count: json['count'],
      description: json['description'],
    );
  }
}
