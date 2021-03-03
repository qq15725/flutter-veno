import 'package:flutter/foundation.dart';

abstract class VenoModel extends ChangeNotifier {
  Map _payload;

  VenoModel([payload]) {
    this._payload = payload ?? {};
  }

  T get<T>(key) => _payload[key];

  void set(key, [value]) {
    Map data = {};
    if (value == null && key is Map) {
      data = key;
    } else {
      data[key] = value;
    }
    if (data.length > 0) {
      data.forEach((key, value) {
        _payload[key] = value;
      });
      super.notifyListeners();
    }
  }

  void delete([key]) {
    if (key == null) {
      _payload.clear();
    } else {
      _payload.remove(key);
    }
    super.notifyListeners();
  }

  Map toMap() => _payload;
}
