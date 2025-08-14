import 'package:universal_html/html.dart' as html;
import 'package:injectable/injectable.dart';

@injectable
class GoogleAuthService {
  static const String _backendUrl = 'http://localhost:8017';
  static const String _tokenKey = 'auth_token';
  static const String _userDataKey = 'user_data';

  /// Redirect to Google OAuth
  void signInWithGoogle() {
    try {
      html.window.open('$_backendUrl/api/auth/google', '_self');
    } catch (e) {
      print('Error opening Google Sign-In: $e');
      rethrow;
    }
  }

  /// Check if current URL contains auth success
  bool isAuthSuccessUrl() {
    final uri = html.window.location.href;
    return uri.contains('/auth/success') || uri.contains('token=');
  }

  /// Extract token from URL
  String? extractTokenFromUrl(String url) {
    try {
      final uri = Uri.parse(url);

      // Try from query parameters
      String? token = uri.queryParameters['token'];

      // Try from fragment (after #)
      if (token == null && uri.fragment.isNotEmpty) {
        final fragmentParams = Uri.splitQueryString(uri.fragment);
        token = fragmentParams['token'];
      }

      // Try regex extraction for different encoding
      if (token == null) {
        final RegExp tokenRegex = RegExp(r'token=([^&]+)');
        final match = tokenRegex.firstMatch(url);
        if (match != null) {
          token = Uri.decodeComponent(match.group(1) ?? '');
        }
      }

      return token;
    } catch (e) {
      print('Error extracting token: $e');
      return null;
    }
  }

  /// Extract user data from URL
  Map<String, dynamic>? extractUserFromUrl(String url) {
    try {
      final uri = Uri.parse(url);

      // Try from query parameters
      String? userJson = uri.queryParameters['user'];

      // Try from fragment
      if (userJson == null && uri.fragment.isNotEmpty) {
        final fragmentParams = Uri.splitQueryString(uri.fragment);
        userJson = fragmentParams['user'];
      }

      // Try individual user fields
      if (userJson == null) {
        final email = uri.queryParameters['email'];
        final name = uri.queryParameters['name'];
        final id = uri.queryParameters['id'];

        if (email != null || name != null || id != null) {
          return {'email': email, 'name': name, 'id': id};
        }
      }

      if (userJson != null) {
        return {'userData': userJson};
      }

      return null;
    } catch (e) {
      print('Error extracting user: $e');
      return null;
    }
  }

  /// Save auth data to localStorage
  void saveAuthData(String token, Map<String, dynamic>? user) {
    try {
      html.window.localStorage[_tokenKey] = token;

      if (user != null && user.isNotEmpty) {
        html.window.localStorage[_userDataKey] = user.toString();
      }

      print('Auth data saved successfully');
    } catch (e) {
      print('Error saving auth data: $e');
      rethrow;
    }
  }

  /// Get saved token
  String? getSavedToken() {
    try {
      return html.window.localStorage[_tokenKey];
    } catch (e) {
      print('Error getting saved token: $e');
      return null;
    }
  }

  /// Get saved user data
  String? getSavedUserData() {
    try {
      return html.window.localStorage[_userDataKey];
    } catch (e) {
      print('Error getting saved user data: $e');
      return null;
    }
  }

  /// Check if user is authenticated
  bool isAuthenticated() {
    final token = getSavedToken();
    return token != null && token.isNotEmpty;
  }

  /// Clear auth data (logout)
  void clearAuthData() {
    try {
      html.window.localStorage.remove(_tokenKey);
      html.window.localStorage.remove(_userDataKey);
      print('Auth data cleared successfully');
    } catch (e) {
      print('Error clearing auth data: $e');
    }
  }

  /// Clean URL from auth parameters
  void cleanUrl() {
    try {
      html.window.history.replaceState(null, '', '/');
    } catch (e) {
      print('Error cleaning URL: $e');
    }
  }
}
