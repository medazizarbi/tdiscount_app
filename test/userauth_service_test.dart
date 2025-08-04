import 'package:flutter_test/flutter_test.dart';
import 'package:tdiscount_app/services/user_auth_service.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// Mock classes
class MockClient extends Mock implements http.Client {}

void main() {
  group('UserAuthService', () {
    late UserAuthService authService;

    setUp(() {
      authService = UserAuthService();
      SharedPreferences.setMockInitialValues({});
    });

    test('logout clears user data from SharedPreferences', () async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', 'abc');
      await prefs.setString('user_email', 'test@example.com');
      await prefs.setString('user_nicename', 'nicename');
      await prefs.setString('user_display_name', 'display');
      await prefs.setString('user_first_name', 'first');
      await prefs.setString('user_last_name', 'last');

      await authService.logout();

      expect(prefs.getString('token'), isNull);
      expect(prefs.getString('user_email'), isNull);
      expect(prefs.getString('user_nicename'), isNull);
      expect(prefs.getString('user_display_name'), isNull);
      expect(prefs.getString('user_first_name'), isNull);
      expect(prefs.getString('user_last_name'), isNull);
    });
  });
}
