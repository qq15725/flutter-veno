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

/// 生成一维路由
///
List<VenoRoute> _genRoutes(
  List<VenoRoute> routes, [
  List<VenoRoute> initialPatternRoutes,
  VenoRoute parentRoute,
]) {
  return routes?.fold(
        initialPatternRoutes ?? [],
        (patternRoutes, route) {
          patternRoutes.add(
            route._clone(
              path: [parentRoute?.path, route.path]
                  .where((path) => path != null && path.isNotEmpty)
                  .join('/'),
              parent: parentRoute,
            ),
          );

          patternRoutes.addAll(
            _genRoutes(route.children, patternRoutes, parentRoute),
          );

          return patternRoutes;
        },
      ) ??
      [];
}
