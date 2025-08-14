import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:test_web_flutter_fe/core/clean_arch_setup/extension/view_abs.dart';
import 'package:test_web_flutter_fe/generated/assets.gen.dart';
import 'package:test_web_flutter_fe/injector.dart';
import 'package:test_web_flutter_fe/module/startup/login/app/ui/widgets/normal_signUp_widget.dart';
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
  void initState() {
    super.initState();
  }

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
            child: Assets.resources.images.aki.image(fit: BoxFit.cover),
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

                    //FomrField
                    Obx(
                      () => NormalSignupWidget(
                        userController: viewModel.usernameTextController,
                        emailController: viewModel.emailTextController,
                        passController: viewModel.passwordTextController,
                        confirmPassController:
                            viewModel.confirmPasswordTextController,
                        fullNameController: viewModel.fullNameTextController,
                        displayNameController:
                            viewModel.displayNameTextController,
                        showPassword: viewModel.showPassword,
                        showConfirmPassword: viewModel.showConfirmPassword,
                        enableRegister: viewModel.enableRegister,
                        onShowPassword: viewModel.onShowPassword,
                        onShowConfirmPassword: viewModel.onShowConfirmPassword,
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
                                ? const Color.fromRGBO(
                                    55,
                                    120,
                                    218,
                                    1,
                                  ) // Xanh khi enable
                                : const Color.fromRGBO(
                                    177,
                                    177,
                                    177,
                                    1,
                                  ), // Xám khi disable
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
}
