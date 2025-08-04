import 'package:flutter_test/flutter_test.dart';
import 'package:tdiscount_app/services/search_service.dart';

void main() {
  group('SearchService', () {
    late SearchService searchService;

    setUp(() {
      searchService = SearchService();
    });

    test('filterUnsupportedImages filters out .avif images', () {
      final urls = [
        'https://example.com/image1.jpg',
        'https://example.com/image2.avif',
        'https://example.com/image3.png',
      ];
      final filtered = searchService.filterUnsupportedImages(urls);
      expect(filtered, contains('https://example.com/image1.jpg'));
      expect(filtered, contains('https://example.com/image3.png'));
      expect(filtered, isNot(contains('https://example.com/image2.avif')));
    });

    test('stripHtmlTags removes HTML tags and decodes entities', () {
      const html = '<p>Hello&nbsp;World</p>';
      final plain = searchService.stripHtmlTags(html);
      expect(plain, 'Hello World');
    });
  });
}
