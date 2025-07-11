import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tdiscount_app/models/product_model.dart';

class SearchService {
  final String baseUrl = "REMOVED_SECRET/";
  final String consumerKey = "REMOVED_SECRET";
  final String consumerSecret = "REMOVED_SECRET";

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
  }) async {
    final url = Uri.parse(
        "${baseUrl}products?search=$search&per_page=$perPage&page=$page&status=publish&stock_status=instock");

    final response = await http.get(
      url,
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

        // Return a new Product with filtered images
        return Product(
          id: product.id,
          name: product.name,
          price: product.price,
          regularPrice: product.regularPrice,
          imageUrls: filteredImageUrls,
          inStock: product.inStock,
          description: product.description,
          shortDescription: product.shortDescription,
          sku: product.sku,
        );
      }).where((product) {
        // Only keep products with at least one image and a name
        return product.imageUrls.isNotEmpty && product.name.isNotEmpty;
      }).toList();

      // Log the number of products fetched and the page number
      print(
          '🔎🔎🔎🔎 [SearchService] Page $page: fetched ${products.length} products.');

      return products;
    } else {
      throw Exception("Erreur lors de la recherche des produits");
    }
  }
}
