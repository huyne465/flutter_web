import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:synchronized/synchronized.dart';
import 'package:test_web_flutter_fe/core/clean_arch_setup/extension/view_model_abs.dart';
import 'package:test_web_flutter_fe/core/clean_arch_setup/extension/unit.dart';
import 'package:test_web_flutter_fe/core/helper/loading_helper.dart';
import 'package:test_web_flutter_fe/core/helper/toast_helper.dart';
import 'package:test_web_flutter_fe/injector.dart';

abstract class AppViewModel extends GetxController implements ViewModel {
  static final _runLock = Lock();

  @override
  void initState() {}

  @override
  void disposeState() {}

  @override
  Future<Unit> showLoading() async {
    await injector.get<LoadingHelper>().show();
    return unit;
  }

  @override
  Future<Unit> hideLoading() async {
    await injector.get<LoadingHelper>().hide();
    return unit;
  }

  @override
  Future<Unit> handleError(dynamic error) async {
    await showToastWithDuration(error.toString());
    return unit;
  }

  @protected
  @override
  Future<bool> run(
    dynamic Function() handler, {
    @Deprecated('Should handle loading from app level')
    required bool shouldShowLoading,
    bool shouldHandleError = true,
    Duration lockTimeout = const Duration(seconds: 30),
  }) async {
    return shouldShowLoading
        ? _runLock.synchronized<bool>(
            () => _run(
              handler,
              shouldShowLoading: shouldShowLoading,
              shouldHandleError: shouldHandleError,
            ),
            timeout: lockTimeout,
          )
        : _run(
            handler,
            shouldShowLoading: shouldShowLoading,
            shouldHandleError: shouldHandleError,
          );
  }

  Future<bool> _run(
    dynamic Function() handler, {
    required bool shouldShowLoading,
    required bool shouldHandleError,
  }) async {
    var success = true;
    try {
      if (shouldShowLoading) {
        await showLoading();
      }
      final result = handler();
      if (result is Future) {
        await result;
      }
    } catch (error) {
      success = false;
      if (shouldHandleError) {
        await handleError(error);
      }
    } finally {
      if (shouldShowLoading) {
        await hideLoading();
      }
    }
    return success;
  }
}
