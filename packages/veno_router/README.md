# veno_router

Flutter 路由

- 嵌套视图
- 路径参数
- query string

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