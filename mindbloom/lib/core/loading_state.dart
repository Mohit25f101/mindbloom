import 'package:flutter/material.dart';

class LoadingState extends ChangeNotifier {
  bool _isLoading = false;
  String? _loadingMessage;

  bool get isLoading => _isLoading;
  String? get loadingMessage => _loadingMessage;

  void startLoading([String? message]) {
    _loadingMessage = message;
    _isLoading = true;
    notifyListeners();
  }

  void stopLoading() {
    _isLoading = false;
    _loadingMessage = null;
    notifyListeners();
  }
}
