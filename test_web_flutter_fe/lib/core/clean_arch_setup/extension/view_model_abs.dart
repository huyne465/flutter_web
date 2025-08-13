import 'package:flutter/widgets.dart';
import 'package:synchronized/synchronized.dart';
import 'package:test_web_flutter_fe/core/clean_arch_setup/extension/unit.dart';

abstract class ViewModel {
  static final _runLock = Lock();

  void initState() {}

  void disposeState() {}

  @protected
  Future<Unit> showLoading();

  @protected
  Future<Unit> hideLoading();

  @protected
  Future<Unit> handleError(dynamic error);

  @protected
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
