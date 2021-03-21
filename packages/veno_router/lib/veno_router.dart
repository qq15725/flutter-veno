import 'package:flutter/material.dart';

part 'util.dart';

part 'veno_router_node.dart';

part 'veno_route.dart';

typedef VenoRoute VenoRouterBefore(VenoRouter router, VenoRoute to);

class VenoRouter {
  VenoRouter({
    @required this.routes,
    this.before,
  }) {
    before = before ?? (_, to) => to;

    boot();
  }

  /// 路由节点
  ///
  List<VenoRoute> routes;

  /// 前缀树根节点
  ///
  VenoRouterNode _node;

  /// 处理后的路由节点
  ///
  List<VenoRoute> _routes;

  /// 处理后的匹配路由索引
  ///
  Map<String, int> _patternRouteIndexs;

  /// 处理后的名称路由索引
  ///
  Map<String, int> _nameRouteIndexs;

  ///
  ///
  VenoRouterBefore before;

  /// 启动
  ///
  void boot() {
    _node = VenoRouterNode();
    _patternRouteIndexs = {};
    _nameRouteIndexs = {};
    (_routes = _genRoutes(routes)).asMap().forEach((index, route) {
      _node.add(route.path);
      _patternRouteIndexs[route.path] = index;
      if (route.name != null) {
        _nameRouteIndexs[route.name] = index;
      }
    });
  }

  /// 解析 [RouteSettings]
  ///
  _parseRouteSettings(RouteSettings settings) {
    List<String> parts = (settings.name ?? '').split('?');

    return {
      'path': parts.first, // 路径
      'params': {}
        ..addAll(_parseQueryString(parts.length == 2 ? parts.last : ''))
        ..addAll(settings.arguments is Map ? settings.arguments : {}), // 所有参数
    };
  }

  /// 识别路径或名称成路由
  ///
  VenoRoute identify(String value, [Map params]) {
    if (_nameRouteIndexs.containsKey(value)) {
      return _routes[_nameRouteIndexs[value]]?._clone(params: params);
    } else {
      VenoRouterNode node = _node.find(value);

      if (node?.pattern == null) {
        return VenoRoute();
      }

      return _routes[_patternRouteIndexs[node.pattern]]?._clone(
        params: (node?.bindings ?? {})..addAll(params ?? {}),
      );
    }
  }

  ///
  ///
  beforeEach(VenoRouterBefore handle) {
    before = handle;
  }

  /// 构建路由工厂
  ///
  RouteFactory routeFactory() {
    return (RouteSettings settings) {
      Map _settings = _parseRouteSettings(settings);

      VenoRoute route = identify(_settings['path']);

      VenoRoute _route = before(
        this,
        route?._clone(
          params: _settings['params']..addAll(route?.params ?? {}),
        ),
      );

      return MaterialPageRoute(
        builder: (BuildContext context) {
          return _route._builder(
            context,
            null,
            _route,
          );
        },
      );
    };
  }
}
