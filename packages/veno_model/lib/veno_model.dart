import 'package:flutter/foundation.dart';

abstract class VenoModel extends ChangeNotifier {
  VenoModel([this._attributes]) {
    _attributes = _attributes ?? {};
  }

  /// 所有属性
  ///
  Map _attributes;

  /// 获取属性
  ///
  T get<T>(key) => _attributes[key];

  /// 设置属性
  ///
  void set(key, [value]) {
    Map data = {};
    if (value == null && key is Map) {
      data = key;
    } else {
      data[key] = value;
    }
    if (data.length > 0) {
      data.forEach((key, value) {
        _attributes[key] = value;
      });
      super.notifyListeners();
    }
  }

  /// 删除属性
  ///
  void delete([key]) {
    if (key == null) {
      _attributes.clear();
    } else {
      _attributes.remove(key);
    }
    super.notifyListeners();
  }

  /// 所有属性 [Map] 形式
  ///
  Map toMap() => _attributes;
}
