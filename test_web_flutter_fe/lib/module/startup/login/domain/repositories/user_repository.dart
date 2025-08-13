import 'package:test_web_flutter_fe/core/clean_arch_setup/network/core_response.dart';
import 'package:test_web_flutter_fe/module/startup/login/domain/model/user.dart';

abstract class UserRepository {
  /// Login user
  Future<CoreResponse> login(String userName, String password);

  /// Sign up new user
  Future<CoreResponse> register(User user);

  /// Get all users
  Future<CoreResponse> getAllUsers();
}
