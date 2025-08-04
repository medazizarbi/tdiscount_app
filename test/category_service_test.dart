import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:tdiscount_app/services/category_service.dart';
import 'package:mockito/mockito.dart';

// ===== Your Category Model =====

class Category {
  final int id;
  final String name;
  final int count;
  final String? description;

  Category({
    required this.id,
    required this.name,
    required this.count,
    this.description,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      count: json['count'] ?? 0,
      description: json['description'],
    );
  }
}

// Create a MockClient using the Mockito package.
class MockClient extends Mock implements http.Client {}

// ===== Test =====

void main() {
  group('CategoryService', () {
    late CategoryService categoryService;

    setUp(() {
      categoryService = CategoryService();
    });

    test('filterUnsupportedImages filters .avif images', () {
      final urls = [
        'https://example.com/image1.jpg',
        'https://example.com/image2.avif',
        'https://example.com/image3.png',
      ];
      final filtered = categoryService.filterUnsupportedImages(urls);
      expect(filtered, contains('https://example.com/image1.jpg'));
      expect(filtered, contains('https://example.com/image3.png'));
      expect(filtered, isNot(contains('https://example.com/image2.avif')));
    });

    test('htmlToPlainText removes HTML tags and decodes entities', () {
      const html = '<p>Hello&nbsp;World &amp; everyone!</p>';
      final plain = categoryService.htmlToPlainText(html);
      expect(plain, 'Hello World & everyone!');
    });
  });
}
