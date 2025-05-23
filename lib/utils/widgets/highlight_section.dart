import 'package:flutter/material.dart';

class HighlightSection extends StatelessWidget {
  final String title;
  final String subtitle;
  final String mainImage;
  final List<Map<String, String>> products; // List of {image, name}
  final Color highlightColorBG; // Renamed variable

  const HighlightSection({
    super.key,
    required this.title,
    required this.subtitle,
    required this.mainImage,
    required this.products,
    this.highlightColorBG = Colors.yellow, // Default color is yellow
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // Make it span full width
      margin: const EdgeInsets.only(
          top: 10, bottom: 10), // Keep only vertical margin
      decoration: BoxDecoration(
        color: highlightColorBG, // Use the renamed variable
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Add padding above the title
          Padding(
            padding: const EdgeInsets.only(top: 20), // Add top padding
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 15), // Slight padding for text readability
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Subtitle
                  Text(
                    title,
                    style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(
                            255, 0, 0, 0)), // Customize the color
                  ),
                  Text(subtitle,
                      style: const TextStyle(
                          fontSize: 12,
                          color: Color.fromARGB(
                              255, 0, 0, 0))), // Customize the color
                  const SizedBox(
                      height: 5), // Space between subtitle and "Voir plus"

                  // "Voir plus" with arrow icon (aligned to the left)
                  GestureDetector(
                    onTap: () {},
                    child: const Row(
                      mainAxisAlignment:
                          MainAxisAlignment.start, // Align to the left
                      children: [
                        Text(
                          "Voir plus",
                          style: TextStyle(
                            fontSize: 14,
                            color: Color.fromARGB(
                                255, 0, 0, 0), // Customize the color
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 5), // Space between text and icon
                        Icon(
                          Icons.arrow_forward,
                          size: 16,
                          color: Color.fromARGB(
                              255, 0, 0, 0), // Match the text color
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20), // Rounded corners
              child: Image.asset(
                mainImage,
                width:
                    MediaQuery.of(context).size.width * 0.9, // Responsive width
                height: 180, // Adjusted height
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 10),
          // Add padding below the 3 images
          Padding(
            padding: const EdgeInsets.only(bottom: 20), // Add bottom padding
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: products.map((product) {
                return _buildProductCard(product['image']!, product['name']!,
                    90, 90); // Resized images
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(
      String imagePath, String title, double width, double height) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(15), // Rounded corners
          child: Image.asset(
            imagePath,
            width: width,
            height: height,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 5),
        Text(title,
            style: const TextStyle(fontSize: 14), textAlign: TextAlign.center),
      ],
    );
  }
}
