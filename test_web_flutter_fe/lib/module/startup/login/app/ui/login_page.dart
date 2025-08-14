import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:test_web_flutter_fe/core/clean_arch_setup/extension/view_abs.dart';
import 'package:test_web_flutter_fe/core/extension/str_ext.dart';
import 'package:test_web_flutter_fe/core/helper/core_theme.dart';
import 'package:test_web_flutter_fe/generated/assets.gen.dart';
import 'package:test_web_flutter_fe/generated/locale_keys.g.dart';
import 'package:test_web_flutter_fe/injector.dart';
import 'package:test_web_flutter_fe/module/startup/login/app/ui/widgets/normal_login_widget.dart';
import 'package:test_web_flutter_fe/module/startup/login/app/ui/widgets/google_icon_widget.dart';
import 'package:test_web_flutter_fe/module/startup/login/app/viewModel/login_viewModel.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ViewState<LoginPage, LoginViewModel> {
  @override
  createViewModel() => injector<LoginViewModel>();

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
            padding: EdgeInsets.only(top: 292.h),
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      LocaleKeys.title_welcome.translate(),
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Obx(() => _loginHandle(viewModel)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _loginHandle(LoginViewModel viewModel) {
    if (viewModel.enableRegister) {
      return Column(
        children: [
          NormalLoginWidget(
            userController: viewModel.usernameTextController,
            passController: viewModel.passwordTextController,
            showPassword: viewModel.showPassword,
            enableRegister: viewModel.enableRegister,
            onShowPassword: viewModel.onShowPassword,
          ),
          SizedBox(height: 20.h),
          ElevatedButton(
            onPressed: () {
              viewModel.onLogin();
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              minimumSize: Size(double.infinity, 48.h),
              backgroundColor: viewModel.enablePasswordLogin
                  ? const Color.fromRGBO(55, 120, 218, 1)
                  : const Color.fromRGBO(109, 177, 237, 1),
              elevation: 0,
            ),
            child: Text(
              LocaleKeys.button_login.translate(),
              style: TextStyle(color: Colors.white, fontSize: 16.sp),
            ),
          ),
          SizedBox(height: 20.h),

          // Divider với text "Hoặc"
          Row(
            children: [
              Expanded(
                child: Divider(
                  color: const Color.fromRGBO(177, 177, 177, 1),
                  thickness: 1,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Text(
                  'Hoặc',
                  style: TextStyle(
                    color: const Color.fromRGBO(177, 177, 177, 1),
                    fontSize: 14.sp,
                  ),
                ),
              ),
              Expanded(
                child: Divider(
                  color: const Color.fromRGBO(177, 177, 177, 1),
                  thickness: 1,
                ),
              ),
            ],
          ),

          SizedBox(height: 20.h),

          // Google Sign-In Button
          ElevatedButton(
            onPressed: () {
              viewModel.signInWithGoogle();
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              minimumSize: Size(double.infinity, 48.h),
              backgroundColor: Colors.white,
              side: const BorderSide(
                color: Color.fromRGBO(221, 221, 221, 1),
                width: 1,
              ),
              elevation: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ImageIcon(
                  Assets.resources.images.google.image().image,
                  size: 20.w,
                  color: const Color.fromRGBO(60, 60, 60, 1),
                ),
                SizedBox(width: 12.w),
                Text(
                  'Đăng nhập bằng Google',
                  style: TextStyle(
                    color: const Color.fromRGBO(60, 60, 60, 1),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 24.h),

          // Register Link
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Chưa có tài khoản? ',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: const Color.fromRGBO(177, 177, 177, 1),
                ),
              ),
              InkWell(
                onTap: () {
                  Get.toNamed('/register');
                },
                child: Text(
                  'Đăng ký ngay',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: const Color.fromRGBO(55, 120, 218, 1),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    } else {
      return Column(
        children: [
          ElevatedButton(
            onPressed: () {
              viewModel.onLogin();
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              minimumSize: Size(double.infinity, 48.h),
              backgroundColor: viewModel.enablePasswordLogin
                  ? const Color.fromRGBO(55, 120, 218, 1)
                  : const Color.fromRGBO(109, 177, 237, 1),
              elevation: 0,
            ),
            child: Text(
              'Đăng nhập',
              style: TextStyle(color: Colors.white, fontSize: 16.sp),
            ),
          ),
          SizedBox(height: 20.h),
          ElevatedButton(
            onPressed: () {
              viewModel.onLogin();
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
              minimumSize: Size(double.infinity, 48.h),
              backgroundColor: Colors.white,
              side: BorderSide(color: CoreTheme.greyColors(), width: 1),
              elevation: 0,
            ).copyWith(splashFactory: NoSplash.splashFactory),
            child: Obx(
              () => AnimatedCrossFade(
                duration: const Duration(milliseconds: 300),
                firstChild: Text(
                  'Đăng nhập bằng tài khoản',
                  style: TextStyle(
                    color: const Color.fromRGBO(55, 120, 218, 1),
                    fontSize: 16.sp,
                  ),
                ),
                secondChild: Text(
                  'Đăng nhập bằng tài khoản',
                  style: TextStyle(
                    color: const Color.fromRGBO(55, 120, 218, 1),
                    fontSize: 16.sp,
                  ),
                ),
                crossFadeState: viewModel.enablePasswordLogin
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
              ),
            ),
          ),
        ],
      );
    }
  }
}
