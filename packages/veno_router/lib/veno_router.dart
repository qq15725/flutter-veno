import 'package:flutter/material.dart';

part 'veno_route.dart';

@immutable
class VenoRouter {
  final List<VenoRoute> routes;

  const VenoRouter({this.routes});

  VenoRoute rootRoute() => VenoRoute(children: routes);

  RouteFactory buildPageRouteFactory() {
    final route = rootRoute();
    return (RouteSettings settings) {
      final paths = settings.name
          .split('/')
          .where(
            (path) => path.isNotEmpty,
          )
          .toList();
      return route.buildPageRoute(paths, 0, settings.arguments);
    };
  }
}
