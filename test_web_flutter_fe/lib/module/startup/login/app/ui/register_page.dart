import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:test_web_flutter_fe/core/clean_arch_setup/extension/view_abs.dart';
import 'package:test_web_flutter_fe/generated/assets.gen.dart';
import 'package:test_web_flutter_fe/injector.dart';
import 'package:test_web_flutter_fe/module/startup/login/app/viewModel/register_viewModel.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ViewState<RegisterPage, RegisterViewModel> {
  @override
  createViewModel() => injector<RegisterViewModel>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            right: 0,
            child: Assets.resources.images.bgLogin.image(fit: BoxFit.cover),
          ),
          Padding(
            padding: EdgeInsets.only(top: 150.h),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.r),
                  topRight: Radius.circular(24.r),
                ),
              ),
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 30.h),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => viewModel.onNavigateToLogin(),
                          icon: const Icon(Icons.arrow_back),
                          padding: EdgeInsets.zero,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'Đăng ký tài khoản',
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Tạo tài khoản mới để bắt đầu sử dụng',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: const Color.fromRGBO(177, 177, 177, 1),
                      ),
                    ),
                    SizedBox(height: 32.h),

                    // Form Fields
                    _buildTextField(
                      controller: viewModel.fullNameTextController,
                      hintText: 'Họ và tên',
                      prefixIcon: Assets.resources.icons.icPerson.image(
                        width: 20.w,
                        height: 20.h,
                      ),
                    ),
                    SizedBox(height: 16.h),

                    _buildTextField(
                      controller: viewModel.usernameTextController,
                      hintText: 'Tên đăng nhập',
                      prefixIcon: Assets.resources.icons.icPerson.image(
                        width: 20.w,
                        height: 20.h,
                      ),
                    ),
                    SizedBox(height: 16.h),

                    _buildTextField(
                      controller: viewModel.emailTextController,
                      hintText: 'Email',
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: Icon(
                        Icons.email_outlined,
                        size: 20.w,
                        color: const Color.fromRGBO(177, 177, 177, 1),
                      ),
                    ),
                    SizedBox(height: 16.h),

                    _buildTextField(
                      controller: viewModel.displayNameTextController,
                      hintText: 'Tên hiển thị (tùy chọn)',
                      prefixIcon: Icon(
                        Icons.badge_outlined,
                        size: 20.w,
                        color: const Color.fromRGBO(177, 177, 177, 1),
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Password Field
                    Obx(
                      () => _buildTextField(
                        controller: viewModel.passwordTextController,
                        hintText: 'Mật khẩu',
                        obscureText: !viewModel.showPassword,
                        prefixIcon: Assets.resources.icons.icLock.image(
                          width: 20.w,
                          height: 20.h,
                        ),
                        suffixIcon: InkWell(
                          onTap: () => viewModel.onShowPassword(),
                          child: Icon(
                            viewModel.showPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: const Color.fromRGBO(177, 177, 177, 1),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Confirm Password Field
                    Obx(
                      () => _buildTextField(
                        controller: viewModel.confirmPasswordTextController,
                        hintText: 'Xác nhận mật khẩu',
                        obscureText: !viewModel.showConfirmPassword,
                        prefixIcon: Assets.resources.icons.icLock.image(
                          width: 20.w,
                          height: 20.h,
                        ),
                        suffixIcon: InkWell(
                          onTap: () => viewModel.onShowConfirmPassword(),
                          child: Icon(
                            viewModel.showConfirmPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: const Color.fromRGBO(177, 177, 177, 1),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),

                    // Password Requirements
                    Text(
                      'Mật khẩu phải có ít nhất 6 ký tự',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: const Color.fromRGBO(177, 177, 177, 1),
                      ),
                    ),
                    SizedBox(height: 32.h),

                    // Register Button
                    Obx(
                      () => SizedBox(
                        width: double.infinity,
                        height: 48.h,
                        child: ElevatedButton(
                          onPressed:
                              viewModel.enableRegister && !viewModel.isLoading
                              ? () => viewModel.onRegister()
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: viewModel.enableRegister
                                ? const Color.fromRGBO(55, 120, 218, 1)
                                : const Color.fromRGBO(177, 177, 177, 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            elevation: 0,
                          ),
                          child: viewModel.isLoading
                              ? SizedBox(
                                  width: 20.w,
                                  height: 20.h,
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : Text(
                                  'Đăng ký',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),

                    // Login Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Đã có tài khoản? ',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: const Color.fromRGBO(177, 177, 177, 1),
                          ),
                        ),
                        InkWell(
                          onTap: () => viewModel.onNavigateToLogin(),
                          child: Text(
                            'Đăng nhập',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: const Color.fromRGBO(55, 120, 218, 1),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 32.h),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    Widget? prefixIcon,
    Widget? suffixIcon,
    bool obscureText = false,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: TextStyle(color: Colors.black, fontSize: 14.sp),
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: const BorderSide(
            color: Color.fromRGBO(177, 177, 177, 1),
            width: 1,
          ),
        ),
        filled: true,
        hintStyle: const TextStyle(color: Color.fromRGBO(177, 177, 177, 1)),
        fillColor: Colors.transparent,
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color.fromRGBO(177, 177, 177, 1)),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Color.fromRGBO(55, 120, 218, 1),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
