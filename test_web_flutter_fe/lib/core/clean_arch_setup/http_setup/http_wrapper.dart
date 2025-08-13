import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_alice/alice.dart';
import 'package:test_web_flutter_fe/config/app_config.dart';
import 'package:test_web_flutter_fe/config/be_config.dart';
import 'package:test_web_flutter_fe/config/data_keys.dart';
import 'package:test_web_flutter_fe/core/clean_arch_setup/extension/unit.dart';
import 'package:test_web_flutter_fe/core/clean_arch_setup/http_setup/http_error.dart';
import 'package:test_web_flutter_fe/core/helper/local_storage_helper.dart';
import 'package:test_web_flutter_fe/injector.dart';

typedef UnauthorizedResponseHandler =
    void Function({required HttpError httpError});

typedef ErrorMessageParser = String? Function({required HttpError httpError});

class HttpClientWrapper {
  final Dio dio = Dio();
  final UnauthorizedResponseHandler? _unauthorizedResponseHandler;
  final ErrorMessageParser _errorMessageParser;

  HttpClientWrapper({
    required BaseOptions options,
    bool verbose = false,
    UnauthorizedResponseHandler? unauthorizedResponseHandler,
    List<Interceptor>? extraInterceptors,
    ErrorMessageParser errorMessageParser = laravelErrorMessageParser,
  }) : _unauthorizedResponseHandler = unauthorizedResponseHandler,
       _errorMessageParser = errorMessageParser {
    dio.options = options;
    dio.interceptors.add(
      InterceptorsWrapper(onRequest: onRequest, onError: onError),
    );

    // Add Alice interceptor for debugging if available
    if (AppConfig.aliceEnabled) {
      dio.interceptors.add(injector<Alice>().getDioInterceptor());
    }

    // Add any extra interceptors if provided
    if (extraInterceptors != null) {
      dio.interceptors.addAll(extraInterceptors);
    }

    if (verbose) {
      dio.interceptors.add(
        LogInterceptor(logPrint: print, requestBody: true, responseBody: true),
      );
    }
  }

  Future<Unit> onRequest(
    RequestOptions option,
    RequestInterceptorHandler handler,
  ) async {
    option.connectTimeout = BackEndConfig.connectTimeout;
    if (LocalStorageHelper.getData(key: DataKeys.token).isNotEmpty &&
        option.path != BackEndConfig.getAllUsersPath) {
      dio.options.headers['Authorization'] =
          'Bearer ${LocalStorageHelper.getData(key: DataKeys.token)}';
    } else {
      LocalStorageHelper.setData(key: DataKeys.token, data: "");
    }
    // print("Request: ${option.method} ${option.path}");
    handler.next(option);
    return unit;
  }

  void onError(DioException e, ErrorInterceptorHandler handler) {
    final httpError = HttpError(
      dioError: e,
      errorMessageParser: _errorMessageParser,
    );

    if (httpError.response?.statusCode == HttpStatus.unauthorized) {
      _unauthorizedResponseHandler?.call(httpError: httpError);
      LocalStorageHelper.clearAll();
    }
    handler.next(httpError);
  }
}
