import 'package:injectable/injectable.dart';
import 'package:test_web_flutter_fe/core/clean_arch_setup/network/core_response.dart';
import 'package:test_web_flutter_fe/module/startup/login/data/datasources/user_dataSource.dart';
import 'package:test_web_flutter_fe/module/startup/login/domain/model/user.dart';
import 'package:test_web_flutter_fe/module/startup/login/domain/repositories/user_repository.dart';

@LazySingleton(as: UserRepository)
class UserRepositoryImpl implements UserRepository {
  final UserDataSource _userDataSource;

  UserRepositoryImpl(this._userDataSource);

  @override
  Future<CoreResponse> login(String userName, String password) async {
    return await _userDataSource.login(userName: userName, password: password);
  }

  @override
  Future<CoreResponse> register(User user) async {
    return await _userDataSource.register(
      userName: user.userName,
      password: user.password,
      email: user.email,
      displayName: user.displayName,
      fullName: user.fullName,
    );
  }

  @override
  Future<CoreResponse> getAllUsers() async {
    return await _userDataSource.getAllUsers();
  }
}
