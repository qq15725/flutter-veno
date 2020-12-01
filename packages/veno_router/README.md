一个 Flutter 路由.

[![Version](https://img.shields.io/pub/v/veno_router)](https://pub.dev/packages/veno_router)

## 特性

- 嵌套路由
- 路径参数[:*]
- Query String

## 快速开始

定义路由

router.dart

```dart
import 'package:flutter/material.dart';
import 'package:veno_router/veno_router.dart';

import 'parent_view.dart';
import 'child_ciew.dart';

final router = VenoRouter(routes: [
  VenoRoute(
    path: '/',
    builder: (Widget child, VenoRoute route) => ParentView(child: child, route: route),
    children: [
      VenoRoute(
        path: '/products/:id',
        builder: (Widget child, VenoRoute route) => ChildView(child: child, route: route),
      ),
    ],
  ),
]);
```

注册 onGenerateRoute 页面路由工厂

main.dart

```dart
import 'package:flutter/material.dart';
import 'router.dart';

void main() {
  runApp(MaterialApp(
    onGenerateRoute: router.buildPageRouteFactory(),
  ));
}
```

## 例子

```dart
import 'package:flutter/material.dart';
import 'package:veno_router/veno_router.dart';

class ParentView extends StatelessWidget {
  Widget child;

  ParentView({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Wrap(
          children: [
            Text('公共'),
            child ??
                OutlineButton(
                  onPressed: () =>
                      Navigator.of(context).pushNamed('/products/1'),
                  child: Text('子页面'),
                ),
          ],
        ),
      ),
    );
  }
}

class ChildView extends StatelessWidget {
  VenoRoute route;

  ChildView({Key key, this.route}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlineButton(
      onPressed: () => Navigator.of(context).pop(),
      child: Text('${route.params} 返回父页面'),
    );
  }
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: VenoRouter(routes: [
        VenoRoute(
          path: '/',
          builder: (child, __) => ParentView(child: child),
          children: [
            VenoRoute(
              path: '/products/:id',
              builder: (_, VenoRoute route) => ChildView(route: route),
            ),
          ],
        ),
      ]).buildPageRouteFactory(),
    );
  }
}

void main() {
  runApp(App());
}
```