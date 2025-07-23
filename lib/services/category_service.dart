import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/category_model.dart';
import '../models/product_model.dart';
import 'package:html_unescape/html_unescape.dart';

class CategoryService {
  String get baseUrl => dotenv.env['WC_BASE_URL'] ?? "";
  String get consumerKey => dotenv.env['WC_CONSUMER_KEY'] ?? "";
  String get consumerSecret => dotenv.env['WC_CONSUMER_SECRET'] ?? "";

  Future<List<Category>> fetchCategories() async {
    const String endpoint =
        "products/categories?parent=0&per_page=8&order=desc&orderby=count";
    final String url = "$baseUrl$endpoint";

    final response = await http.get(
      Uri.parse(url),
      headers: _getAuthHeaders(),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) {
        final category = Category.fromJson(json);
        return Category(
          id: category.id,
          name: category.name.replaceAll("&amp;", "&"),
          count: category.count,
        );
      }).toList()
        ..sort((a, b) {
          if (a.name == "Autres catégories") return 1;
          if (b.name == "Autres catégories") return -1;
          return 0;
        });
    }
    throw Exception("Failed to load categories: ${response.statusCode}");
  }

  /// Filters out unsupported image formats (currently .avif)
  List<String> filterUnsupportedImages(List<String> imageUrls) {
    return imageUrls
        .where((url) => !url.toLowerCase().endsWith('.avif'))
        .toList();
  }

  Future<List<Product>> fetchProductsByCategory(
      int categoryId, int page, int perPage) async {
    final String endpoint =
        "products?category=$categoryId&page=$page&per_page=$perPage&status=publish&stock_status=instock";
    final String url = "$baseUrl$endpoint";

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: _getAuthHeaders(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        final products = data.map((json) {
          final product = Product.fromJson(json);

          final cleanedDescription = htmlToPlainText(product.description);
          final cleanedShortDescription =
              htmlToPlainText(product.shortDescription);

          // Use the filter method here
          final filteredImageUrls = filterUnsupportedImages(product.imageUrls);

          final updatedProduct = Product(
            id: product.id,
            name: product.name,
            price: product.price,
            regularPrice: product.price == product.regularPrice
                ? null
                : product.regularPrice,
            imageUrls: filteredImageUrls,
            inStock: product.inStock,
            description: cleanedDescription,
            shortDescription: cleanedShortDescription,
            sku: product.sku,
            relatedIds: product.relatedIds, // NEW: Include related IDs
          );

          return updatedProduct;
        }).where((product) {
          final isValid =
              product.imageUrls.isNotEmpty && product.name.isNotEmpty;
          return isValid;
        }).toList();

        return products;
      } else {
        throw Exception("Failed to load products: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching products: $e");
    }
  }

  Future<List<Category>> fetchSubCategories(
      int parentCategoryId, String parentCategoryName) async {
    final String endpoint = "products/categories?parent=$parentCategoryId";
    final String url = "$baseUrl$endpoint";

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization':
              'Basic ${base64Encode(utf8.encode('$consumerKey:$consumerSecret'))}',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        // Map the data to Category objects and replace "&amp;" with "&"
        List<Category> subCategories = data.map((json) {
          final category = Category.fromJson(json);

          // Replace "&amp;" with "&" in the category name
          final updatedName = category.name.replaceAll("&amp;", "&");

          // Clean the description using htmlToPlainText
          final cleanedDescription = htmlToPlainText(category.description);

          // Return a new Category object with the updated name, count, and cleaned description
          return Category(
            id: category.id,
            name: updatedName,
            count: category.count, // Include the count field
            description: cleanedDescription, // Use the cleaned description
          );
        }).toList();

        // If no subcategories are found, fetch the parent category details
        if (subCategories.isEmpty) {
          // Fetch the parent category details
          final parentCategory = await fetchCategoryById(parentCategoryId);

          if (parentCategory != null) {
            subCategories.add(parentCategory);
          }
        }

        return subCategories;
      } else {
        throw Exception("Failed to load subcategories: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching subcategories: $e");
    }
  }

  Future<Category?> fetchCategoryById(int categoryId) async {
    final String endpoint = "products/categories/$categoryId";
    final String url = "$baseUrl$endpoint";

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization':
              'Basic ${base64Encode(utf8.encode('$consumerKey:$consumerSecret'))}',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        // Parse the category details
        final category = Category.fromJson(data);

        return category;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Map<String, String> _getAuthHeaders() {
    return {
      'Authorization':
          'Basic ${base64Encode(utf8.encode('$consumerKey:$consumerSecret'))}',
    };
  }

  String htmlToPlainText(String? htmlString) {
    if (htmlString == null) return '';
    final regex = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: true);
    // Remove HTML tags and decode HTML entities
    final withoutTags =
        htmlString.replaceAll(regex, '').replaceAll('&nbsp;', ' ').trim();
    return HtmlUnescape().convert(withoutTags);
  }
}
