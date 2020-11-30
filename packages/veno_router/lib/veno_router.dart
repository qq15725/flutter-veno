import 'package:flutter/material.dart';

part 'util.dart';

part 'veno_router_node.dart';

part 'veno_route.dart';

class VenoRouter {
  List<VenoRoute> routes = [];

  VenoRouter({this.routes});

  /// 规则映射
  ///
  Map<String, Map> get _patternMap {
    Map<String, Map> map = {};
    routes.forEach((route) {
      map.addAll(route._patternMap());
    });
    return map;
  }

  /// 前缀树根节点
  ///
  VenoRouterNode get _node {
    final VenoRouterNode node = VenoRouterNode();
    _patternMap.forEach((pattern, _) {
      node.add(pattern);
    });
    return node;
  }

  /// 解析 query string
  ///
  Map _parseQueryString(String qs) {
    Map map = {};
    qs.split('&').forEach((String v) {
      if (!v.isEmpty) {
        List<String> arr = v.split('=');
        map[arr[0]] = arr.length > 1 ? arr[1] : null;
      }
    });
    return map;
  }

  /// 构建页面路由工厂
  ///
  RouteFactory buildPageRouteFactory() {
    return (RouteSettings settings) {
      String path = settings.name;
      Map params = settings.arguments is Map ? settings.arguments : {};
      if (path.isNotEmpty) {
        List<String> paths = settings.name.split('?');
        path = paths[0];
        if (paths.length > 1) {
          params.addAll(_parseQueryString(paths[1] ?? ''));
        }
      }
      VenoRouterNode node = _node.find(path);
      if (node?.value != null) {
        params.addAll(node.value);
      }
      Map item = _patternMap[node?.pattern] ?? {};
      VenoRoute route = item['route'];
      VenoRouteBuilder buildr = item['builder'] ?? _defaultVenoRouteBuilder;
      return MaterialPageRoute(
        builder: (_) {
          return buildr(null, route?._clone(params: params));
        },
      );
    };
  }
}
