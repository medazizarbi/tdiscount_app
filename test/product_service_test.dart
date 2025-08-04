import 'package:flutter_test/flutter_test.dart';
import 'package:tdiscount_app/services/produit_service.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

// Mock http.Client
class MockClient extends Mock implements http.Client {}

void main() {
  group('ProductService', () {
    late ProductService productService;

    setUp(() {
      productService = ProductService();
    });

    test('filterUnsupportedImages filters unsupported formats', () {
      final urls = [
        'https://example.com/image1.jpg',
        'https://example.com/image2.avif',
        'https://example.com/image3.png',
      ];
      final filtered = productService.filterUnsupportedImages(urls);
      expect(filtered, contains('https://example.com/image1.jpg'));
      expect(filtered, contains('https://example.com/image3.png'));
      expect(filtered, isNot(contains('https://example.com/image2.avif')));
    });

    test('stripHtmlTags removes HTML tags and decodes entities', () {
      final html = '<p>Hello&nbsp;World</p>';
      final plain = productService.stripHtmlTags(html);
      expect(plain, 'Hello World');
    });
  });
}
