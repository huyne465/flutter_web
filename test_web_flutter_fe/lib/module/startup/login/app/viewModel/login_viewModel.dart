// ignore_for_file: avoid_print
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:test_web_flutter_fe/config/app_routes.dart';
import 'package:test_web_flutter_fe/core/clean_arch_setup/abstraction/app_view_model.dart';
import 'package:test_web_flutter_fe/core/clean_arch_setup/extension/unit.dart';
import 'package:test_web_flutter_fe/module/startup/login/domain/usecase/login_usecase.dart';
import 'package:test_web_flutter_fe/module/startup/login/data/service/google_auth_service.dart';
import 'package:universal_html/html.dart' as html;

@injectable
class LoginViewModel extends AppViewModel {
  final _showPassword = false.obs;
  final _enablePasswordLogin = false.obs;
  final _enableRegister = true.obs;
  bool get enableRegister => _enableRegister.value;

  bool get showPassword => _showPassword.value;

  bool get enablePasswordLogin => _enablePasswordLogin.value;

  TextEditingController get usernameTextController => _usernameTextController;

  TextEditingController get passwordTextController => _passwordTextController;

  final _usernameTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  final LoginUsecase _loginUsecase;
  final GoogleAuthService _googleAuthService;

  LoginViewModel(this._loginUsecase, this._googleAuthService);

  @override
  void initState() {
    super.initState();
    // _selectedSchool.value = constSchool;
    _usernameTextController.addListener(() {
      if (usernameTextController.text.isNotEmpty &&
          passwordTextController.text.isNotEmpty) {
        _enablePasswordLogin.value = true;
      } else {
        _enablePasswordLogin.value = false;
      }
    });
    _passwordTextController.addListener(() {
      if (usernameTextController.text.isNotEmpty &&
          passwordTextController.text.isNotEmpty) {
        _enablePasswordLogin.value = true;
      } else {
        _enablePasswordLogin.value = false;
      }
    });

    // Check for auth success on page load
    _checkAuthSuccess();
  }

  Future<Unit> onShowPassword(bool value) async {
    _showPassword.value = value;
    return unit;
  }

  Future<Unit> onLogin() async {
    run(
      () async {
        final response = await _loginUsecase.run(
          username: usernameTextController.text,
          password: passwordTextController.text,
        );
        if (response.isSuccess) {
          Get.snackbar(
            'Thành công',
            'Đăng Nhập thành công!',
            snackPosition: SnackPosition.TOP,
            backgroundColor: const Color.fromRGBO(229, 251, 234, 1),
            icon: Container(
              width: 24.w,
              height: 24.w,
              decoration: const BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: Colors.white),
            ),
          );
          // Navigate back to dashboard
          Get.offNamed(AppRoutes.dashboard);
        }
      },
      shouldShowLoading: true,
      shouldHandleError: true,
    );
    return unit;
  }

  void extractToken(String token) {
    final jwt = JWT.decode(token);
    print(jwt.payload);
  }

  // Google Sign-In methods
  Future<Unit> signInWithGoogle() async {
    try {
      _googleAuthService.signInWithGoogle();
    } catch (e) {
      await handleError('Lỗi khi mở Google Sign-In: $e');
    }
    return unit;
  }

  void _checkAuthSuccess() {
    if (_googleAuthService.isAuthSuccessUrl()) {
      _handleAuthSuccess();
    }
  }

  void _handleAuthSuccess() {
    final uri = html.window.location.href;
    print('Handling auth success for URL: $uri'); // Debug log

    try {
      final token = _googleAuthService.extractTokenFromUrl(uri);
      final user = _googleAuthService.extractUserFromUrl(uri);

      print('Extracted token: $token'); // Debug log
      print('Extracted user: $user'); // Debug log

      if (token != null && token.isNotEmpty) {
        // Lưu token và user data
        _googleAuthService.saveAuthData(token, user);

        // Clean URL
        _googleAuthService.cleanUrl();

        // Hiển thị thông báo thành công
        Get.snackbar(
          'Thành công',
          'Đăng nhập Google thành công!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: const Color.fromRGBO(229, 251, 234, 1),
          icon: Container(
            width: 24.w,
            height: 24.w,
            decoration: const BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, color: Colors.white),
          ),
        );

        // Navigate to dashboard
        Get.offNamed(AppRoutes.dashboard);
      } else {
        throw Exception('Token không hợp lệ');
      }
    } catch (e) {
      print('Error handling auth success: $e'); // Debug log
      handleError('Lỗi xử lý đăng nhập Google: $e');
    }
  }

  // Method để lấy token đã lưu
  String? getSavedToken() {
    return _googleAuthService.getSavedToken();
  }

  // Method để xóa auth data (logout)
  Future<Unit> logout() async {
    try {
      _googleAuthService.clearAuthData();

      Get.snackbar(
        'Thành công',
        'Đăng xuất thành công!',
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color.fromRGBO(229, 251, 234, 1),
      );

      Get.offAllNamed(AppRoutes.login);
    } catch (e) {
      print('Error during logout: $e');
    }
    return unit;
  }

  @override
  Future<Unit> handleError(dynamic error) async {
    Get.snackbar(
      error.toString(),
      "Lỗi",
      snackPosition: SnackPosition.TOP,
      backgroundColor: const Color.fromRGBO(251, 234, 229, 1),
      icon: Container(
        width: 24.w,
        height: 24.w,
        decoration: const BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.close, color: Colors.white),
      ),
    );
    return unit;
  }
}
