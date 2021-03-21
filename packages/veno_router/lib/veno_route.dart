part of 'veno_router.dart';

typedef Widget VenoRouteWidgetBuilder(
  BuildContext context,
  Widget child,
  VenoRoute route,
);

Widget _defaultVenoRouteWidgetBuilder(_, Widget child, __) {
  return child ?? SizedBox.shrink();
}

@immutable
class VenoRoute {
  const VenoRoute({
    this.name,
    this.path,
    this.builder = _defaultVenoRouteWidgetBuilder,
    this.children,
    this.params,
    this.parent,
  });

  /// 名称
  ///
  final String name;

  /// 路径
  ///
  final String path;

  /// 子路由
  ///
  final List<VenoRoute> children;

  /// 构建
  ///
  final VenoRouteWidgetBuilder builder;

  /// 参数
  ///
  final Map params;

  ///
  ///
  final VenoRoute parent;

  ///
  ///
  VenoRoute _clone({
    String name,
    String path,
    VenoRouteWidgetBuilder builder,
    List<VenoRoute> children,
    Map params,
    VenoRoute parent,
  }) {
    return VenoRoute(
      name: name ?? this.name,
      path: path ?? this.path,
      builder: builder ?? this.builder,
      children: children ?? this.children,
      params: params ?? this.params,
      parent: parent ?? this.parent,
    );
  }

  ///
  ///
  _builder(BuildContext context, Widget child, VenoRoute route) {
    Widget widget = builder(context, child, route);
    return parent?.builder(context, widget, null) ?? widget;
  }
}
