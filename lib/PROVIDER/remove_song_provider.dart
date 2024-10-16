import 'package:flutter/material.dart';

class RemoveSongFromList extends ChangeNotifier {
  bool _isSelect = false;
  bool get isSelect => _isSelect;
  set setValue(bool value) {
    _isSelect = value;
    notifyListeners();
  }

  // void setValue(bool bool) {}
}
