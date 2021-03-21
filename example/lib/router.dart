import 'package:veno/veno.dart';
import 'package:flutter/material.dart';
import 'widgets/pages/home_page.dart';

VenoRouter router = VenoRouter(
  routes: [
    VenoRoute(
      path: '/users/:id/tags',
      builder: (_, __, route) =>
          Center(child: Text("${route.params.toString()}_tags")),
    ),
    VenoRoute(
      path: '/users/:id',
      builder: (_, __, route) => Center(child: Text(route.params.toString())),
    ),
    VenoRoute(
      path: '/',
      builder: (_, __, ___) => HomePage(title: 'Hello Veno'),
    ),
  ],
);
