import 'package:flutter/material.dart';
import 'package:test_web_flutter_fe/core/clean_arch_setup/extension/view_model_abs.dart';

abstract class ViewState<T extends StatefulWidget, M extends ViewModel>
    extends State<T> {
  late M _viewModel;

  M get viewModel => _viewModel;

  @protected
  void loadArguments() {}

  @protected
  M createViewModel();

  @override
  void initState() {
    _viewModel = createViewModel();
    super.initState();
    loadArguments();
    _viewModel.initState();
  }

  @override
  void didUpdateWidget(covariant T oldWidget) {
    super.didUpdateWidget(oldWidget);
    loadArguments();
  }

  @override
  void dispose() {
    _viewModel.disposeState();
    super.dispose();
  }
}
