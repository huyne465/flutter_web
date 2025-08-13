import 'package:test_web_flutter_fe/core/clean_arch_setup/network/core_response.dart';

abstract class UserDataSource {
  /// Login user
  Future<CoreResponse> login({String? userName, String? password});

  /// Sign up new user
  Future<CoreResponse> register({
    String? userName,
    String? password,
    String? email,
    String? displayName,
    String? fullName,
  });

  /// Get all users
  Future<CoreResponse> getAllUsers();
}
