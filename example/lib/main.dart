import 'package:flutter/material.dart';
import 'package:veno/veno.dart';
import 'app.dart';
import 'router.dart';

void main() {
  runApp(
    Veno(
      singleton: true,
      router: router,
      child: App(),
    ),
  );
}
