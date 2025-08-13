import 'package:easy_localization/easy_localization.dart' as el;

extension StringExt on String? {
  bool isNotEmpty() {
    if (this != null && this!.isNotEmpty) {
      return true;
    }
    return false;
  }
}

extension StringNonNullExt on String {
  String translate() {
    return el.tr(this);
  }
}
