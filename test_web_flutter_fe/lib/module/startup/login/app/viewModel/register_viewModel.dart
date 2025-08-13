import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:test_web_flutter_fe/config/app_routes.dart';
import 'package:test_web_flutter_fe/core/clean_arch_setup/abstraction/app_view_model.dart';
import 'package:test_web_flutter_fe/core/clean_arch_setup/extension/unit.dart';
import 'package:test_web_flutter_fe/module/startup/login/domain/usecase/register_usecase.dart';

@injectable
class RegisterViewModel extends AppViewModel {
  final _showPassword = false.obs;
  final _showConfirmPassword = false.obs;
  final _enableRegister = false.obs;
  final _isLoading = false.obs;

  bool get showPassword => _showPassword.value;
  bool get showConfirmPassword => _showConfirmPassword.value;
  bool get enableRegister => _enableRegister.value;
  bool get isLoading => _isLoading.value;

  final _usernameTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _confirmPasswordTextController = TextEditingController();
  final _fullNameTextController = TextEditingController();
  final _displayNameTextController = TextEditingController();

  TextEditingController get usernameTextController => _usernameTextController;
  TextEditingController get emailTextController => _emailTextController;
  TextEditingController get passwordTextController => _passwordTextController;
  TextEditingController get confirmPasswordTextController =>
      _confirmPasswordTextController;
  TextEditingController get fullNameTextController => _fullNameTextController;
  TextEditingController get displayNameTextController =>
      _displayNameTextController;

  final RegisterUsecase _registerUsecase;

  RegisterViewModel(this._registerUsecase);

  @override
  void onInit() {
    super.onInit();
    _setupFormValidation();
  }

  void _setupFormValidation() {
    // Listen to all text controllers for form validation
    _usernameTextController.addListener(_validateForm);
    _emailTextController.addListener(_validateForm);
    _passwordTextController.addListener(_validateForm);
    _confirmPasswordTextController.addListener(_validateForm);
    _fullNameTextController.addListener(_validateForm);
  }

  void _validateForm() {
    final isValid =
        _usernameTextController.text.isNotEmpty &&
        _emailTextController.text.isNotEmpty &&
        _passwordTextController.text.isNotEmpty &&
        _confirmPasswordTextController.text.isNotEmpty &&
        _fullNameTextController.text.isNotEmpty &&
        _isValidEmail(_emailTextController.text) &&
        _passwordTextController.text == _confirmPasswordTextController.text &&
        _passwordTextController.text.length >= 6;

    _enableRegister.value = isValid;
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  Future<Unit> onShowPassword() async {
    _showPassword.value = !_showPassword.value;
    return unit;
  }

  Future<Unit> onShowConfirmPassword() async {
    _showConfirmPassword.value = !_showConfirmPassword.value;
    return unit;
  }

  Future<Unit> onRegister() async {
    if (!enableRegister) return unit;

    _isLoading.value = true;

    await run(
      () async {
        final response = await _registerUsecase.run(
          username: _usernameTextController.text.trim(),
          email: _emailTextController.text.trim(),
          password: _passwordTextController.text,
          fullName: _fullNameTextController.text.trim(),
          displayName: _displayNameTextController.text.trim().isEmpty
              ? _usernameTextController.text.trim()
              : _displayNameTextController.text.trim(),
        );

        if (response.isSuccess) {
          Get.snackbar(
            'Thành công',
            'Đăng ký tài khoản thành công!',
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
          // Navigate back to login page
          Get.offNamed(AppRoutes.login);
        } else {
          throw Exception(response.message ?? 'Đăng ký thất bại');
        }
      },
      shouldShowLoading: false,
      shouldHandleError: true,
    );

    _isLoading.value = false;
    return unit;
  }

  Future<Unit> onNavigateToLogin() async {
    Get.offNamed(AppRoutes.login);
    return unit;
  }

  @override
  Future<Unit> handleError(dynamic error) async {
    Get.snackbar(
      'Lỗi',
      error.toString(),
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

  @override
  void onClose() {
    _usernameTextController.dispose();
    _emailTextController.dispose();
    _passwordTextController.dispose();
    _confirmPasswordTextController.dispose();
    _fullNameTextController.dispose();
    _displayNameTextController.dispose();
    super.onClose();
  }
}
