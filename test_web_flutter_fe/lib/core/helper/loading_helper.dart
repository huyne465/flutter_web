import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:injectable/injectable.dart';
import 'package:test_web_flutter_fe/core/clean_arch_setup/extension/unit.dart';
import 'package:test_web_flutter_fe/core/extension/str_ext.dart';
import 'package:test_web_flutter_fe/generated/locale_keys.g.dart';

@lazySingleton
class LoadingHelper {
  int _counter = 0;

  Future<Unit> show() async {
    if (EasyLoading.isShow) {
      _counter++;
    } else {
      await EasyLoading.show(status: LocaleKeys.loading.translate());
    }
    return unit;
  }

  Future<Unit> hide() async {
    if (_counter == 0) {
      await EasyLoading.dismiss();
    } else {
      _counter--;
    }
    return unit;
  }
}
