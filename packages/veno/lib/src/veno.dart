import 'package:flutter/material.dart';

import 'package:veno_container/veno_container.dart';

typedef void VenoProvider(Veno app);

class Veno extends VenoContainer {
  Veno({
    Key key,
    Widget child,
    List<VenoProvider> providers = const [],
    bool singleton = false,
  }) : super(key: key, child: child) {
    // 设置 providers
    setupProviders(providers);

    // 设置单例
    if (singleton) {
      Veno.singleton(veno: this);
    }
  }

  /// 单例
  ///
  static Veno _singleton;

  /// 往上找到 Veno 实例
  ///
  static Veno of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Veno>();
  }

  /// 获取或设置 Veno 单例
  ///
  static Veno singleton({Veno veno}) {
    if (veno != null) {
      Veno._singleton = veno;
    }

    return Veno._singleton;
  }

  /// Setup Providers
  ///
  void setupProviders(List<VenoProvider> providers) {
    providers.forEach((provider) {
      provider(this);
    });
  }

  /// 获取
  ///
  T get<T>([key]) {
    return offsetGet<T>(key);
  }

  /// 设置
  ///
  T set<T>(dynamic value, {dynamic key}) {
    return offsetSet<T>(value, key: key);
  }
}
