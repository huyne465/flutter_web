import 'package:fluttertoast/fluttertoast.dart';

Future<bool?> showToastWithDuration(
  String message, {
  Duration duration = const Duration(seconds: 2),
}) {
  return Fluttertoast.showToast(
    msg: message,
    gravity: ToastGravity.BOTTOM,
    fontSize: 14.0,
    toastLength: Toast.LENGTH_SHORT,
    timeInSecForIosWeb: duration.inSeconds,
  );
}
