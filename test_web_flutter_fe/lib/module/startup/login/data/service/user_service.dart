import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:test_web_flutter_fe/config/be_config.dart';
import 'package:test_web_flutter_fe/core/clean_arch_setup/http_setup/http_wrapper.dart';
import 'package:test_web_flutter_fe/core/clean_arch_setup/network/core_response.dart';
import 'package:test_web_flutter_fe/injector.dart';

part 'user_service.g.dart';

@lazySingleton
@RestApi(baseUrl: BackEndConfig.baseUrl)
abstract class UserService {
  @factoryMethod
  factory UserService() => _UserService(injector<HttpClientWrapper>().dio);

  @POST("/login")
  Future<CoreResponse> login(@Body() Map<String, dynamic> map);

  @POST("/create-user")
  Future<CoreResponse> register(@Body() Map<String, dynamic> map);

  @GET("/users/")
  Future<CoreResponse> getAllUsers();
}
