import 'package:flutter/material.dart';

class Price extends ChangeNotifier {
  double _price = 0;

  double get getPrice {
    return _price;
  }

  void resetPrice() {
    _price = 0.0;
  }

  void add(double val) {
    _price += val;
    notifyListeners();
  }

  void subtract(double val) {
    if (_price - val >= 0) {
      _price -= val;
      notifyListeners();
    }
  }

  set setPrice(price) => _price;
}
