import 'package:flutter/material.dart';

class GlobalFunction with ChangeNotifier {
  int _currentPage = 0;
  set changePage(currentPage) {
    print(_currentPage);
    _currentPage = currentPage;
    print(_currentPage);
    notifyListeners();
  }

  int get currentPage => _currentPage;
}
