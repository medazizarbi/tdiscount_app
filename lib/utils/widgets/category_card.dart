import 'package:flutter/material.dart';
import '../../models/category_model.dart';
import '../../views/sub_categorie.dart';

class CategoryCard extends StatelessWidget {
  final Category category;
  final double cardWidth;

  const CategoryCard({
    super.key,
    required this.category,
    required this.cardWidth,
  });

  // Same icons map as in home_screen.dart
  static const Map<int, String> categoryIcons = {
    347: "assets/images/white_cat_icons/tel.webp", // tel et tablettes
    204: "assets/images/white_cat_icons/electro.webp", // electro
    267: "assets/images/white_cat_icons/informatique.png", // informatique
    780: "assets/images/white_cat_icons/maison.png", // maison et bricolage
    407: "assets/images/white_cat_icons/printer.png", //impression
    696:
        "assets/images/white_cat_icons/vetement.webp", // vetement et accessoires
    753: "assets/images/white_cat_icons/ordinateur.webp", // oridnateur bureau
    401: "assets/images/white_cat_icons/autre.png", //autres categories
  };

  static const String defaultCategoryIcon =
      "assets/images/white_cat_icons/elec.png";

  @override
  Widget build(BuildContext context) {
    final iconPath = categoryIcons[category.id] ?? defaultCategoryIcon;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                SubCategorieScreen(
              categoryId: category.id,
              categoryName: category.name,
              categoryCount: category.count,
            ),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.easeInOut;

              var tween = Tween(begin: begin, end: end).chain(
                CurveTween(curve: curve),
              );

              var offsetAnimation = animation.drive(tween);

              return SlideTransition(
                position: offsetAnimation,
                child: child,
              );
            },
          ),
        );
      },
      child: Container(
        width: cardWidth,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            // Icon with circular background
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 21, 21, 21),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: SizedBox(
                  width: 60,
                  height: 60,
                  child: Image.asset(
                    iconPath,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        defaultCategoryIcon,
                        fit: BoxFit.contain,
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Name (up to 2 lines)
            Container(
              width: cardWidth,
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                category.name,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget to display the list of categories from ViewModel
class CategoryList extends StatelessWidget {
  final List<Category> categories; // Accept categories from ViewModel

  const CategoryList({
    super.key,
    required this.categories, // Required parameter
  });

  // Function to calculate text width for 2 lines max
  double _calculateTextWidth(String text, TextStyle style, double maxWidth) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 2,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(maxWidth: maxWidth);
    return textPainter.width;
  }

  // Function to get the optimal width for text to fit properly
  double _getOptimalWidth(String text, TextStyle style) {
    final words = text.split(' ');

    if (words.length == 1) {
      // Single word - calculate width needed
      return _calculateTextWidth(text, style, double.infinity);
    } else {
      // Multiple words - try to fit in reasonable width
      // Start with a reasonable minimum width
      double testWidth = 80.0;
      double maxTestWidth = 200.0;

      while (testWidth <= maxTestWidth) {
        final TextPainter textPainter = TextPainter(
          text: TextSpan(text: text, style: style),
          maxLines: 2,
          textDirection: TextDirection.ltr,
        );
        textPainter.layout(maxWidth: testWidth);

        // If text fits in 2 lines or less with this width, use it
        if (textPainter.didExceedMaxLines == false) {
          return testWidth;
        }

        testWidth += 10.0;
      }

      return maxTestWidth; // fallback
    }
  }

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) {
      return const SizedBox.shrink();
    }

    // Calculate the maximum width needed for all category names
    const textStyle = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.bold,
      height: 1.2,
    );

    double maxRequiredWidth = 110.0;

    for (final category in categories) {
      final requiredWidth = _getOptimalWidth(category.name, textStyle);
      if (requiredWidth > maxRequiredWidth) {
        maxRequiredWidth = requiredWidth;
      }
    }

    final cardWidth = (maxRequiredWidth + 20).clamp(110.0, 180.0);

    return SizedBox(
      height: 170,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return CategoryCard(
            category: categories[index],
            cardWidth: cardWidth,
          );
        },
      ),
    );
  }
}
