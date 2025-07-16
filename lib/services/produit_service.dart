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

  // Helper method to clean HTML content (you might need to add html package)
  String htmlToPlainText(String htmlString) {
    // Remove HTML tags - you might want to use a proper HTML parser
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    return htmlString.replaceAll(exp, '').trim();
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

  Future<Product> fetchProductById(int productId) async {
    final String endpoint = "products/$productId";
    final String url = "$baseUrl$endpoint";

    try {
      print("Fetching product with ID: $productId");

      final response = await http.get(
        Uri.parse(url),
        headers: _getAuthHeaders(),
      );

      print("Response status code: ${response.statusCode}");

      if (response.statusCode == 200) {
        print("Response body: ${response.body}");

        final Map<String, dynamic> data = json.decode(response.body);

        // Map the data to a Product object
        final product = Product.fromJson(data);

        // Clean HTML content
        final cleanedDescription = product.description != null
            ? htmlToPlainText(product.description!)
            : null;

        final cleanedShortDescription = product.shortDescription != null
            ? htmlToPlainText(product.shortDescription!)
            : null;

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

        print(
            "Product ID: ${updatedProduct.id}, Name: ${updatedProduct.name}, Price: ${updatedProduct.price}, Regular Price: ${updatedProduct.regularPrice}, Image URL: ${updatedProduct.imageUrls}");
        print(
            "Related IDs: ${updatedProduct.relatedIds}"); // NEW: Log related IDs

        return updatedProduct;
      } else {
        print("Failed to load product. Status code: ${response.statusCode}");
        print("Response body: ${response.body}");
        throw Exception("Failed to load product: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching product: $e");
      throw Exception("Error fetching product: $e");
    }
  }

  // NEW: Method to fetch multiple related products by their IDs
  Future<List<Product>> fetchRelatedProducts(List<int> relatedIds) async {
    if (relatedIds.isEmpty) {
      print("No related product IDs provided");
      return [];
    }

    print('⏳ Fetching ${relatedIds.length} related products');

    List<Product> relatedProducts = [];

    for (int relatedId in relatedIds) {
      try {
        final product = await fetchProductById(relatedId);
        relatedProducts.add(product);
        print('✅ Fetched related product: ${product.name}');
      } catch (e) {
        print('❌ Error fetching related product $relatedId: $e');
        // Continue with other products even if one fails
      }
    }

    print('✅ Successfully fetched ${relatedProducts.length} related products');
    return relatedProducts;
  }

  // NEW: More efficient bulk fetch method using WooCommerce include parameter
  Future<List<Product>> fetchProductsByIds(List<int> productIds) async {
    if (productIds.isEmpty) {
      print("No product IDs provided");
      return [];
    }

    // Convert IDs to comma-separated string
    final String idsString = productIds.join(',');
    final String endpoint =
        "products?include=$idsString&per_page=${productIds.length}";
    final String url = "$baseUrl$endpoint";

    print('⏳ Bulk fetching products by IDs: $idsString');

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: _getAuthHeaders(),
      );

      print('✅ Bulk fetch response: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        print('📦 Bulk fetched ${data.length} products');

        final products = data.map((json) {
          final product = Product.fromJson(json);

          // Clean HTML content
          final cleanedDescription = product.description != null
              ? htmlToPlainText(product.description!)
              : null;

          final cleanedShortDescription = product.shortDescription != null
              ? htmlToPlainText(product.shortDescription!)
              : null;

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

        print('✅ Processed ${products.length} valid products');
        return products;
      } else {
        throw Exception(
            "Failed to bulk fetch products: ${response.statusCode}");
      }
    } catch (e) {
      print('❌ Error in bulk fetch: $e');
      throw Exception("Error bulk fetching products: $e");
    }
  }

  // NEW: Convenience method to get related products for a specific product
  Future<List<Product>> getRelatedProductsFor(Product product) async {
    if (!product.hasRelatedProducts) {
      print("Product ${product.name} has no related products");
      return [];
    }

    print("Getting related products for: ${product.name}");

    // Use the more efficient bulk fetch method
    return await fetchProductsByIds(product.relatedIds);
  }
}
