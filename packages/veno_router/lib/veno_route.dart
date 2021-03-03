part of 'veno_router.dart';

typedef Widget VenoRouteWidgetBuilder(
    BuildContext context, Widget child, VenoRoute route);

Widget _defaultVenoRouteWidgetBuilder(_, Widget child, __) =>
    child ?? SizedBox.shrink();

@immutable
class VenoRoute {
  const VenoRoute({
    this.name,
    this.path,
    this.builder = _defaultVenoRouteWidgetBuilder,
    this.children,
    this.params,
  });

  VenoRoute _clone({Map params}) => VenoRoute(
        name: name,
        path: path,
        builder: builder,
        children: children,
        params: params,
      );

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
}
