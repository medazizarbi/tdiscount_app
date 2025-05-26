import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final String name;
  final String? imagePath;

  const CategoryCard({
    super.key,
    required this.name,
    this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 16), // Space between cards
      child: Column(
        children: [
          // Image
          if (imagePath != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(12), // Rounded corners
              child: Image.asset(
                imagePath!,
                width: 110, // Adjust the width as needed
                height: 110, // Adjust the height as needed
                fit: BoxFit.cover,
              ),
            ),
          const SizedBox(height: 10), // Space between image and text
          // Name
          Text(
            name,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

// Static list of categories
final List<Map<String, String>> categories = [
  {
    'name': 'Smartphones',
    'imagePath': 'assets/images/produit1.jpg', // Add your image path
  },
  {
    'name': 'Informatiques',
    'imagePath': 'assets/images/prod2.jpg', // Add your image path
  },
  {
    'name': 'Electronics',
    'imagePath': 'assets/images/produit1.jpg', // Add your image path
  },
  {
    'name': 'Fashion',
    'imagePath': 'assets/images/prod2.jpg', // Add your image path
  },
];

// Widget to display the list of categories in a horizontal list
// Widget to display the list of categories in a horizontal list
class CategoryList extends StatelessWidget {
  const CategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150, // Adjust the height as needed
      child: ListView.builder(
        scrollDirection: Axis.horizontal, // Horizontal scroll
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return CategoryCard(
            name: categories[index]['name']!,
            imagePath: categories[index]['imagePath'],
          );
        },
      ),
    );
  }
}
