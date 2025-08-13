import 'package:get/get.dart';
import 'package:test_web_flutter_fe/config/app_routes.dart';
import 'package:test_web_flutter_fe/injector.dart';
import 'package:test_web_flutter_fe/module/startup/login/app/ui/dasboard_page.dart';
import 'package:test_web_flutter_fe/module/startup/login/app/ui/login_page.dart';
import 'package:test_web_flutter_fe/module/startup/login/app/ui/register_page.dart';
import 'package:test_web_flutter_fe/module/startup/login/app/viewModel/login_viewModel.dart';
import 'package:test_web_flutter_fe/module/startup/login/app/viewModel/register_viewModel.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginPage(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => const RegisterPage(),
      binding: RegisterBinding(),
    ),
    GetPage(name: AppRoutes.dashboard, page: () => DashboardPage()),
  ];
}

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginViewModel>(() => injector<LoginViewModel>());
  }
}

class RegisterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RegisterViewModel>(() => injector<RegisterViewModel>());
  }
}
