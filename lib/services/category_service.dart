import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category_model.dart';
import '../models/product_model.dart';
import 'package:html/parser.dart' show parse;
import 'package:html_unescape/html_unescape.dart';

class CategoryService {
  final String baseUrl = "REMOVED_SECRET/";
  final String consumerKey = "REMOVED_SECRET";
  final String consumerSecret = "REMOVED_SECRET";

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

  Future<List<Product>> fetchProductsByCategory(
      int categoryId, int page, int perPage) async {
    final String endpoint =
        "products?category=$categoryId&page=$page&per_page=$perPage";
    final String url = "$baseUrl$endpoint";

    print('⏳ [API Request] Starting to fetch products for:');
    print('   - Category ID: $categoryId');
    print('   - Page: $page');
    print('   - Items per page: $perPage');
    print('   - URL: $url');

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: _getAuthHeaders(),
      );

      print('✅ [API Response] Received response:');
      print('   - Status Code: ${response.statusCode}');
      print('   - URL: ${response.request?.url}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        print('📦 [Data Processing] Total products received: ${data.length}');

        final products = data.map((json) {
          final product = Product.fromJson(json);

          final cleanedDescription = product.description != null
              ? htmlToPlainText(product.description!)
              : null;

          final cleanedShortDescription = product.shortDescription != null
              ? htmlToPlainText(product.shortDescription!)
              : null;

          print('🖼️ Product: ${product.name}');
          print('   - Total Images: ${product.imageUrls.length}');
          for (var imgUrl in product.imageUrls) {
            print('     • $imgUrl');
          }
          final updatedProduct = Product(
            id: product.id,
            name: product.name,
            price: product.price,
            regularPrice: product.price == product.regularPrice
                ? null
                : product.regularPrice,
            imageUrls: product.imageUrls,
            inStock: product.inStock,
            description: cleanedDescription,
            shortDescription: cleanedShortDescription,
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
      print("Fetching subcategories for parent category ID: $parentCategoryId");

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization':
              'Basic ${base64Encode(utf8.encode('$consumerKey:$consumerSecret'))}',
        },
      );

      print("Response status code: ${response.statusCode}");

      if (response.statusCode == 200) {
        print("Response body: ${response.body}");

        final List<dynamic> data = json.decode(response.body);

        // Map the data to Category objects and replace "&amp;" with "&"
        List<Category> subCategories = data.map((json) {
          final category = Category.fromJson(json);

          // Replace "&amp;" with "&" in the category name
          final updatedName = category.name.replaceAll("&amp;", "&");

          // Clean the description using htmlToPlainText
          final cleanedDescription = category.description != null
              ? htmlToPlainText(category.description!)
              : null;

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
          print(
              "No subcategories found for category ID: $parentCategoryId. Fetching parent category details.");

          // Fetch the parent category details
          final parentCategory = await fetchCategoryById(parentCategoryId);

          if (parentCategory != null) {
            subCategories.add(parentCategory);
          }
        }

        // Print each subcategory's details
        for (var subCategory in subCategories) {
          print(
              "SubCategory ID: ${subCategory.id}, Name: ${subCategory.name}, Count: ${subCategory.count}, Description: ${subCategory.description}");
        }

        return subCategories;
      } else {
        print(
            "Failed to load subcategories. Status code: ${response.statusCode}");
        print("Response body: ${response.body}");
        throw Exception("Failed to load subcategories: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching subcategories: $e");
      throw Exception("Error fetching subcategories: $e");
    }
  }

  Future<Category?> fetchCategoryById(int categoryId) async {
    final String endpoint = "products/categories/$categoryId";
    final String url = "$baseUrl$endpoint";

    try {
      print("Fetching category details for ID: $categoryId");

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization':
              'Basic ${base64Encode(utf8.encode('$consumerKey:$consumerSecret'))}',
        },
      );

      print("Response status code: ${response.statusCode}");

      if (response.statusCode == 200) {
        print("Response body: ${response.body}");

        final Map<String, dynamic> data = json.decode(response.body);

        // Parse the category details
        final category = Category.fromJson(data);

        print(
            "Fetched Category - ID: ${category.id}, Name: ${category.name}, Count: ${category.count}");

        return category;
      } else {
        print("Failed to fetch category. Status code: ${response.statusCode}");
        print("Response body: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Error fetching category: $e");
      return null;
    }
  }

  Map<String, String> _getAuthHeaders() {
    return {
      'Authorization':
          'Basic ${base64Encode(utf8.encode('$consumerKey:$consumerSecret'))}',
    };
  }

  String htmlToPlainText(String htmlString) {
    final document = parse(htmlString);
    final String parsed = document.body?.text ?? '';
    return HtmlUnescape().convert(parsed);
  }
}
