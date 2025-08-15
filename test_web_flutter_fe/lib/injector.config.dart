// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:event_bus/event_bus.dart' as _i1017;
import 'package:flutter/material.dart' as _i409;
import 'package:flutter_alice/alice.dart' as _i934;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import 'core/clean_arch_setup/http_setup/http_wrapper.dart' as _i746;
import 'core/helper/loading_helper.dart' as _i749;
import 'injector.dart' as _i811;
import 'module/startup/login/app/ui/socketTest_page.dart' as _i636;
import 'module/startup/login/app/viewModel/login_viewModel.dart' as _i479;
import 'module/startup/login/app/viewModel/register_viewModel.dart' as _i359;
import 'module/startup/login/data/datasources/user_dataSource.dart' as _i1040;
import 'module/startup/login/data/repository/user_remote_dataSource.dart'
    as _i75;
import 'module/startup/login/data/repository/user_repo_impl.dart' as _i184;
import 'module/startup/login/data/service/google_auth_service.dart' as _i199;
import 'module/startup/login/data/service/socket_service.dart' as _i245;
import 'module/startup/login/data/service/user_service.dart' as _i1062;
import 'module/startup/login/domain/repositories/user_repository.dart' as _i854;
import 'module/startup/login/domain/usecase/login_usecase.dart' as _i922;
import 'module/startup/login/domain/usecase/register_usecase.dart' as _i484;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final appModule = _$AppModule();
    gh.factory<_i199.GoogleAuthService>(() => _i199.GoogleAuthService());
    gh.lazySingleton<_i749.LoadingHelper>(() => _i749.LoadingHelper());
    gh.lazySingleton<_i1017.EventBus>(() => appModule.getEventBus());
    gh.lazySingleton<_i361.Dio>(() => appModule.getDio());
    gh.lazySingleton<_i746.HttpClientWrapper>(
      () => appModule.getHttpClientWrapper(),
    );
    gh.lazySingleton<_i934.Alice>(() => appModule.getAlice());
    gh.lazySingleton<_i1062.UserService>(() => _i1062.UserService());
    gh.factory<_i245.SocketService>(
      () => _i245.SocketService(gh<_i199.GoogleAuthService>()),
    );
    gh.lazySingleton<_i1040.UserDataSource>(
      () => _i75.UserRemoteDatasource(gh<_i1062.UserService>()),
    );
    gh.factory<_i636.SocketTestPage>(
      () => _i636.SocketTestPage(
        key: gh<_i409.Key>(),
        socketService: gh<_i245.SocketService>(),
        authService: gh<_i199.GoogleAuthService>(),
      ),
    );
    gh.lazySingleton<_i922.LoginUsecase>(
      () => _i922.LoginUsecase(gh<_i1040.UserDataSource>()),
    );
    gh.lazySingleton<_i484.RegisterUsecase>(
      () => _i484.RegisterUsecase(gh<_i1040.UserDataSource>()),
    );
    gh.lazySingleton<_i854.UserRepository>(
      () => _i184.UserRepositoryImpl(gh<_i1040.UserDataSource>()),
    );
    gh.factory<_i359.RegisterViewModel>(
      () => _i359.RegisterViewModel(gh<_i484.RegisterUsecase>()),
    );
    gh.factory<_i479.LoginViewModel>(
      () => _i479.LoginViewModel(
        gh<_i922.LoginUsecase>(),
        gh<_i199.GoogleAuthService>(),
      ),
    );
    return this;
  }
}

class _$AppModule extends _i811.AppModule {}
