import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter_alice/alice.dart';
import 'package:test_web_flutter_fe/config/be_config.dart';
import 'package:test_web_flutter_fe/core/clean_arch_setup/http_setup/http_wrapper.dart';
import 'package:test_web_flutter_fe/injector.config.dart';
import 'package:dio/dio.dart';

final injector = GetIt.instance;

@InjectableInit(
  initializerName: 'init', // default
  preferRelativeImports: true, // default
  asExtension: true, // default
)
Future<void> configureDependencies() async {
  // Initialize SharedPreferences first
  final sharedPreferences = await SharedPreferences.getInstance();
  injector.registerSingleton<SharedPreferences>(sharedPreferences);

  // Then initialize other dependencies
  injector.init();
}

@module
abstract class AppModule {
  // Define your dependencies here
  // For example:
  // @singleton
  // MyService get myService => MyServiceImpl();
  @lazySingleton
  EventBus getEventBus() => EventBus();

  @lazySingleton
  Dio getDio() {
    final dio = Dio();
    dio.options.baseUrl = BackEndConfig.baseUrl;
    dio.options.connectTimeout = BackEndConfig.connectTimeout;
    dio.options.receiveTimeout = BackEndConfig.receiveTimeout;
    return dio;
  }

  @lazySingleton
  HttpClientWrapper getHttpClientWrapper() {
    final options = BaseOptions(
      baseUrl: BackEndConfig.baseUrl,
      connectTimeout: BackEndConfig.connectTimeout,
      receiveTimeout: BackEndConfig.receiveTimeout,
    );
    return HttpClientWrapper(options: options, verbose: true);
  }

  @lazySingleton
  Alice getAlice() {
    return Alice();
  }
}
