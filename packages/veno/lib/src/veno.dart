import 'package:flutter/material.dart';

import 'package:veno_container/veno_container.dart';

typedef void VenoProvider(Veno app);

class Veno extends VenoContainer {
  Veno({Key key, Widget child, List<VenoProvider> providers})
      : super(key: key, child: child) {
    providers.forEach((provider) {
      provider(this);
    });
  }

  static Veno of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Veno>();
  }

  T get<T>([key]) {
    return offsetGet<T>(key);
  }

  T set<T>(dynamic value, {dynamic key}) {
    return offsetSet<T>(value, key: key);
  }
}
