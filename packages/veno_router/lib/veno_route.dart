part of 'veno_router.dart';

typedef Widget VenoRouteBuilder(Widget child, VenoRoute currentRoute);

Widget _defaultVenoRouteBuilder(Widget child, _) {
  return child ?? SizedBox.shrink();
}

@immutable
class VenoRoute {
  final String name;
  final String path;
  final List<VenoRoute> children;
  final VenoRouteBuilder builder;
  final Map params;

  const VenoRoute({
    this.name,
    this.path,
    this.builder = _defaultVenoRouteBuilder,
    this.children,
    this.params,
  });

  Map<String, Map> _patternMap({VenoRoute parentRoute}) {
    String pattern = parentRoute == null ? path : "${parentRoute.path}/${path}";

    final item = {
      'route': this,
      'builder': (Widget child, VenoRoute route) {
        Widget widget = this.builder(child, route);
        if (parentRoute == null) {
          return widget;
        }
        return parentRoute.builder(widget, null);
      },
    };

    Map<String, Map> map = {pattern: item};

    (children ?? []).forEach((child) {
      map.addAll(
        child._patternMap(parentRoute: this),
      );
    });
    return map;
  }

  VenoRoute _clone({Map params}) {
    return VenoRoute(
      name: name,
      path: path,
      builder: builder,
      children: children,
      params: params,
    );
  }
}
