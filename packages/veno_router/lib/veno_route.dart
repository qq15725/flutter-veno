part of 'veno_router.dart';

typedef Widget VRouteBuilder(Widget child, Object arguments);

Widget _defaultVRouteBuilder(Widget child, Object arguments) =>
    child ?? SizedBox.shrink();

@immutable
class VenoRoute {
  final String path;
  final List<VenoRoute> children;
  final VRouteBuilder builder;

  const VenoRoute({
    this.path,
    this.builder = _defaultVRouteBuilder,
    this.children,
  });

  String get _path => path?.replaceFirst(RegExp(r'/'), '') ?? '';

  VenoRoute findChild(_path) {
    return children?.firstWhere(
      (route) => route._path.isEmpty || route._path == _path,
      orElse: () => null,
    );
  }

  Widget build(List<String> paths, int index, Object arguments) {
    if (index == paths.length) {
      return builder(null, arguments);
    }
    final child = findChild(paths[index]);
    if (path?.isNotEmpty ?? false) {
      index += 1;
    }
    return builder(child?.build(paths, index, arguments), null);
  }

  Route buildPageRoute(List<String> paths, int index, Object arguments) {
    return PageRouteBuilder<dynamic>(
      pageBuilder: (_, __, ___) => build(paths, index, arguments),
    );
  }
}
