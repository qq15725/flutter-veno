part of 'veno_router.dart';

/// 匹配模式拆分
///
List<String> _patternToParts(String pattern) {
  List<String> parts = [];
  pattern.split('/').where((part) => part.isNotEmpty).forEach((part) {
    parts.add(part);
    if (part.startsWith('*')) {
      return;
    }
  });
  return parts;
}

/// 解析查询字符串
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

/// 生成一维简化路由
///
List<Map> _genSimpleRoutes(List<VenoRoute> routes, [
  List<Map> initialPatternRoutes,
  VenoRoute parentRoute,
]) {
  return routes?.fold(
    initialPatternRoutes ?? [],
        (patternRoutes, route) {
      patternRoutes.add({
        'route': route,
        'name': route.name,
        'pattern': [parentRoute?.path, route.path]
            .where((path) => path != null && path.isNotEmpty)
            .join('/'),
        'builder': (BuildContext context, Widget child, VenoRoute route) {
          Widget widget = route.builder(context, child, route);
          return parentRoute?.builder(context, widget, null) ?? widget;
        },
      });

      patternRoutes.addAll(
        _genSimpleRoutes(route.children, patternRoutes, parentRoute),
      );

      return patternRoutes;
    },
  ) ?? [];
}
