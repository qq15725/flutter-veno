import 'package:flutter/material.dart';

class VenoContainer extends InheritedWidget {
  VenoContainer({Key key, Widget child}) : super(key: key, child: child);

  Map<String, dynamic> _instances = {};

  T offsetGet<T>([key]) {
    if (key == null) {
      key = T.toString();
    }
    return _instances[key];
  }

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

  Map<String, dynamic> getInstances() {
    return _instances;
  }

  static VenoContainer of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<VenoContainer>();
  }

  @override
  bool updateShouldNotify(VenoContainer old) {
    return old.getInstances() != getInstances();
  }
}
