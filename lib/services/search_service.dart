import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tdiscount_app/models/product_model.dart';

class SearchService {
  String get baseUrl => dotenv.env['WC_BASE_URL'] ?? "";
  String get consumerKey => dotenv.env['WC_CONSUMER_KEY'] ?? "";
  String get consumerSecret => dotenv.env['WC_CONSUMER_SECRET'] ?? "";

  // Filter out .avif images
  List<String> filterUnsupportedImages(List<String> imageUrls) {
    return imageUrls
        .where((url) => !url.toLowerCase().endsWith('.avif'))
        .toList();
  }

  Future<List<Product>> searchProducts({
    required String search,
    required int page,
    required int perPage,
    double? minPrice,
    double? maxPrice,
    String? order, // 'asc' or 'desc'
  }) async {
    // Build the query parameters
    final queryParams = <String, String>{
      'search': search,
      'per_page': perPage.toString(),
      'page': page.toString(),
      'status': 'publish',
      'stock_status': 'instock',
    };

    // Add filter parameters only if they are provided
    if (minPrice != null) {
      queryParams['min_price'] = minPrice.toString();
    }

    if (maxPrice != null) {
      queryParams['max_price'] = maxPrice.toString();
    }

    if (order != null && order.isNotEmpty) {
      queryParams['order'] = order;
      queryParams['orderby'] =
          'price'; // Order by price when order is specified
    }

    // Build the URL with query parameters
    final uri =
        Uri.parse("${baseUrl}products").replace(queryParameters: queryParams);

    final response = await http.get(
      uri,
      headers: {
        'Authorization':
            'Basic ${base64Encode(utf8.encode('$consumerKey:$consumerSecret'))}',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      final products = data.map((json) {
        final product = Product.fromJson(json);

        // Filter images
        final filteredImageUrls = filterUnsupportedImages(product.imageUrls);

        // Clean descriptions
        final cleanDescription = stripHtmlTags(product.description);
        final cleanShortDescription = stripHtmlTags(product.shortDescription);

        // Return a new Product with filtered images and cleaned descriptions
        return Product(
          id: product.id,
          name: product.name,
          price: product.price,
          regularPrice: product.regularPrice,
          imageUrls: filteredImageUrls,
          inStock: product.inStock,
          description: cleanDescription,
          shortDescription: cleanShortDescription,
          sku: product.sku,
          relatedIds: product.relatedIds,
        );
      }).where((product) {
        // Only keep products with at least one image and a name
        return product.imageUrls.isNotEmpty && product.name.isNotEmpty;
      }).toList();

      // Log the number of products fetched and the page number
      print(
          '🔎🔎🔎🔎 [SearchService] Page $page: fetched ${products.length} products with filters - min: $minPrice, max: $maxPrice, order: $order');

      return products;
    } else {
      throw Exception("Erreur lors de la recherche des produits");
    }
  }

  // Add this utility function in your service or a utils file
  String stripHtmlTags(String? htmlText) {
    if (htmlText == null) return '';
    final regex = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: true);
    return htmlText.replaceAll(regex, '').replaceAll('&nbsp;', ' ').trim();
  }
}
