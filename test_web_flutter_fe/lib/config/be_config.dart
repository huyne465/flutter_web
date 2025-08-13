class BackEndConfig {
  static const String baseUrl = 'http://localhost:8017/api/auth';
  static const Duration connectTimeout = Duration(seconds: 120);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const String getAllUsersPath = "http://localhost:8017/api/auth/users/";
}
