import 'package:flutter/material.dart';

part 'util.dart';

part 'veno_router_node.dart';

part 'veno_route.dart';

class VenoRouter {
  VenoRouter({
    @required this.routes,
  }) {
    boot();
  }

  /// 启动
  ///
  void boot() {
    _node = VenoRouterNode();
    _patternRouteIndexs = {};
    _nameRouteIndexs = {};
    (_routes = _genSimpleRoutes(routes)).asMap().forEach((index, route) {
      if (route['pattern'] != null) {
        _node.add(route['pattern']);
        _patternRouteIndexs[route['pattern']] = index;
      }
      if (route['name'] != null) {
        _nameRouteIndexs[route['name']] = index;
      }
    });
  }

  /// 路由节点
  ///
  List<VenoRoute> routes;

  /// 前缀树根节点
  ///
  VenoRouterNode _node;

  /// 处理后的路由节点
  ///
  List<Map> _routes;

  /// 处理后的匹配路由索引
  ///
  Map<String, int> _patternRouteIndexs;

  /// 处理后的名称路由索引
  ///
  Map<String, int> _nameRouteIndexs;

  /// 构建路由工厂
  ///
  RouteFactory buildRouteFactory() {
    return (RouteSettings settings) {
      String path = settings.name;
      Map params = {};
      // 合并入参
      if (settings.arguments is Map) {
        params.addAll(settings.arguments);
      }
      // 存在路径
      if (path.isNotEmpty) {
        List<String> paths = settings.name.split('?');
        path = paths[0];
        if (paths.length > 1) {
          params.addAll(_parseQueryString(paths[1] ?? ''));
        }
      }
      // 查询节点
      VenoRouterNode node = _node.find(path);
      // 合并节点路径参数
      if (node?.value != null) {
        params.addAll(node.value);
      }
      String pattern = node?.pattern;
      int index = _patternRouteIndexs[pattern];
      if (index == null) {
        index = _nameRouteIndexs[pattern];
      }
      Map item = index == null ? {} : _routes[index];
      VenoRoute route = item['route'];
      VenoRouteWidgetBuilder buildr =
          item['builder'] ?? _defaultVenoRouteWidgetBuilder;
      return MaterialPageRoute(builder: (BuildContext context) {
        return buildr(
          context,
          null,
          route?._clone(params: params),
        );
      });
    };
  }
}
