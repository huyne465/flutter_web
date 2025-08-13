import 'package:injectable/injectable.dart';
import 'package:test_web_flutter_fe/core/clean_arch_setup/abstraction/app_immutable.dart';
import 'package:test_web_flutter_fe/core/clean_arch_setup/network/core_response.dart';
import 'package:test_web_flutter_fe/module/startup/login/data/datasources/user_dataSource.dart';

@lazySingleton
class LoginUsecase extends Usecase {
  final UserDataSource _datasource;

  const LoginUsecase(this._datasource);

  Future<CoreResponse> run({String? username, String? password}) =>
      _datasource.login(userName: username, password: password);
}
