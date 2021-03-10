import 'package:flutter/material.dart';

class VenoContainer extends InheritedWidget {
  VenoContainer({
    Key key,
    Widget child,
  }) : super(key: key, child: child);

  /// 实例列表
  ///
  Map<String, dynamic> _instances = {};

  /// 获取所有实例
  ///
  Map<String, dynamic> getInstances() => _instances;

  /// 获取实例
  ///
  T offsetGet<T>([key]) {
    return _instances[key ?? T?.toString()];
  }

  /// [offsetGet] 别名
  ///
  T get<T>([key]) {
    return offsetGet<T>(key);
  }

  /// 设置实例
  ///
  T offsetSet<T>(dynamic value, {dynamic key}) {
    if (key != null) {
      if (key is Type) {
        key = key.toString();
      }
    } else if (T != null) {
      key = T.toString();
    } else {
      return value;
    }
    _instances[key] = value;
    return value;
  }

  /// [offsetSet] 别名
  ///
  T set<T>(dynamic value, {dynamic key}) {
    return offsetSet<T>(value, key: key);
  }

  /// 子树向上寻找 [VenoContainer] 实例
  ///
  static VenoContainer of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<VenoContainer>();
  }

  /// 视图更新
  ///
  @override
  bool updateShouldNotify(VenoContainer old) {
    return old._instances != _instances;
  }
}
