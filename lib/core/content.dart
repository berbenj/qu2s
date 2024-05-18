import 'package:flutter/foundation.dart';

class Content<T> extends ChangeNotifier implements ValueListenable<T> {
  T _value;

  Content(T value) : _value = value;

  @override
  T get value => _value;

  set value(T newValue) {
    if (_value != newValue) {
      _value = newValue;
      notifyListeners();
    }
  }
}
