import 'dart:collection';
import 'package:injectable/injectable.dart';
import 'package:test_web_flutter_fe/core/clean_arch_setup/network/core_response.dart';
import 'package:test_web_flutter_fe/module/startup/login/data/datasources/user_dataSource.dart';
import 'package:test_web_flutter_fe/module/startup/login/data/service/user_service.dart';

@LazySingleton(as: UserDataSource)
class UserRemoteDatasource implements UserDataSource {
  final UserService _userService;

  UserRemoteDatasource(this._userService);

  @override
  Future<CoreResponse> login({String? userName, String? password}) async {
    final map = HashMap<String, String>();
    map['userName'] = userName ?? '';
    map['password'] = password ?? '';
    return await _userService.login(map);
  }

  @override
  Future<CoreResponse> register({
    String? userName,
    String? password,
    String? email,
    String? displayName,
    String? fullName,
  }) async {
    final map = HashMap<String, String>();
    map['userName'] = userName ?? '';
    map['password'] = password ?? '';
    map['email'] = email ?? '';
    map['displayName'] = displayName ?? '';
    map['fullName'] = fullName ?? '';
    return await _userService.register(map);
  }

  @override
  Future<CoreResponse> getAllUsers() async {
    return await _userService.getAllUsers();
  }
}
