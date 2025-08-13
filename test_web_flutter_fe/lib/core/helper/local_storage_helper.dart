import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_web_flutter_fe/config/data_keys.dart';
import 'package:test_web_flutter_fe/core/clean_arch_setup/extension/unit.dart';
import 'package:test_web_flutter_fe/injector.dart';

class LocalStorageHelper {
  static String getData({required String key}) {
    return injector<SharedPreferences>().getString(key) ?? "";
  }

  static Future<Unit> setData({
    required String key,
    required String? data,
  }) async {
    injector<SharedPreferences>().setString(key, data ?? "");
    return unit;
  }

  static Future<Unit> clearAll() async {
    injector<SharedPreferences>().clear();
    return unit;
  }

  static String getToken() {
    return "Bearer ${LocalStorageHelper.getData(key: DataKeys.token)}";
  }

  static bool getBool({required String key}) {
    return injector<SharedPreferences>().getBool(key) ?? false;
  }

  static Future<Unit> setBool({
    required String key,
    required bool value,
  }) async {
    await injector<SharedPreferences>().setBool(key, value);
    return unit;
  }
}
