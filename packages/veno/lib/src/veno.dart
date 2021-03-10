import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:veno_container/veno_container.dart';
import 'package:veno_router/veno_router.dart';
import 'veno_provider.dart';
import 'providers/shared_preferences_provider.dart';
import 'providers/error_handle_provider.dart';

class Veno extends VenoContainer {
  Veno({
    Key key,
    Widget child,
    this.router,
    this.providers,
    this.onError,
    bool singleton = false,
  }) : super(key: key, child: child) {
    boot();

    if (singleton) {
      Veno.singleton(this);
    }
  }

  /// 单例
  ///
  static Veno _singleton;

  /// Providers
  ///
  List<VenoProvider> providers;

  /// 合并后的 Providers
  ///
  List<VenoProvider> get _providers => [
        ErrorHandleProvider(),
        SharedPreferencesProvider(),
      ]..addAll(providers ?? []);

  /// 路由
  ///
  VenoRouter router;

  /// 错误捕获
  ///
  FlutterExceptionHandler onError;

  /// 子树向上寻找 [Veno] 实例
  ///
  @override
  static Veno of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Veno>();
  }

  /// 获取/设置 [Veno] 单例
  ///
  static Veno singleton([Veno veno]) {
    if (veno != null) {
      Veno._singleton = veno;
    }

    return Veno._singleton;
  }

  /// 启动
  ///
  Future<void> boot() async {
    await _registerProviders();
    await _bootProviders();
  }

  /// 注册所有 [VenoProvider]
  ///
  Future<void> _registerProviders() async {
    for (int i = 0; i < _providers.length; i++) {
      await _providers[i].registerProvider(this);
    }
  }

  /// 启动所有 [VenoProvider]
  ///
  Future<void> _bootProviders() async {
    for (int i = 0; i < _providers.length; i++) {
      await _providers[i].bootProvider(this);
    }
  }

  /// 构建页面路由工厂
  ///
  RouteFactory buildRouteFactory() => router?.buildRouteFactory();
}