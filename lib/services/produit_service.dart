import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/product_model.dart'; // Import your Product model

class ProductService {
  String get baseUrl => dotenv.env['WC_BASE_URL'] ?? "";
  String get consumerKey => dotenv.env['WC_CONSUMER_KEY'] ?? "";
  String get consumerSecret => dotenv.env['WC_CONSUMER_SECRET'] ?? "";

  // Helper method to get authentication headers
  Map<String, String> _getAuthHeaders() {
    return {
      'Authorization':
          'Basic ${base64Encode(utf8.encode('$consumerKey:$consumerSecret'))}',
    };
  }

  // Helper method to filter unsupported images (if you have this logic)
  List<String> filterUnsupportedImages(List<String> imageUrls) {
    return imageUrls.where((url) {
      // Add your filtering logic here
      return url.isNotEmpty &&
          (url.endsWith('.jpg') ||
              url.endsWith('.jpeg') ||
              url.endsWith('.png') ||
              url.endsWith('.webp'));
    }).toList();
  }

  // Utility method to strip HTML tags and handle nulls
  String stripHtmlTags(String? htmlText) {
    if (htmlText == null) return '';
    final regex = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: true);
    return htmlText.replaceAll(regex, '').replaceAll('&nbsp;', ' ').trim();
  }

  Future<Product> fetchProductById(int productId) async {
    final String endpoint = "products/$productId";
    final String url = "$baseUrl$endpoint";

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: _getAuthHeaders(),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        // Map the data to a Product object
        final product = Product.fromJson(data);

        // Clean HTML content
        final cleanedDescription = stripHtmlTags(product.description);
        final cleanedShortDescription = stripHtmlTags(product.shortDescription);

        // Filter image URLs
        final filteredImageUrls = filterUnsupportedImages(product.imageUrls);

        // Create updated product with cleaned data and related IDs
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
      } else {
        throw Exception("Failed to load product: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching product: $e");
    }
  }

  // NEW: Method to fetch multiple related products by their IDs
  Future<List<Product>> fetchRelatedProducts(List<int> relatedIds) async {
    if (relatedIds.isEmpty) {
      return [];
    }

    List<Product> relatedProducts = [];

    for (int relatedId in relatedIds) {
      try {
        final product = await fetchProductById(relatedId);
        relatedProducts.add(product);
      } catch (e) {
        // Continue with other products even if one fails
      }
    }

    return relatedProducts;
  }

  // NEW: More efficient bulk fetch method using WooCommerce include parameter
  Future<List<Product>> fetchProductsByIds(List<int> productIds) async {
    if (productIds.isEmpty) {
      return [];
    }

    // Convert IDs to comma-separated string
    final String idsString = productIds.join(',');
    final String endpoint =
        "products?include=$idsString&per_page=${productIds.length}";
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

          // Clean HTML content
          final cleanedDescription = stripHtmlTags(product.description);
          final cleanedShortDescription =
              stripHtmlTags(product.shortDescription);

          // Filter image URLs
          final filteredImageUrls = filterUnsupportedImages(product.imageUrls);

          return Product(
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
        }).where((product) {
          final isValid =
              product.imageUrls.isNotEmpty && product.name.isNotEmpty;
          return isValid;
        }).toList();

        return products;
      } else {
        throw Exception(
            "Failed to bulk fetch products: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error bulk fetching products: $e");
    }
  }

  // NEW: Convenience method to get related products for a specific product
  Future<List<Product>> getRelatedProductsFor(Product product) async {
    if (!product.hasRelatedProducts) {
      return [];
    }

    // Use the more efficient bulk fetch method
    return await fetchProductsByIds(product.relatedIds);
  }
}
