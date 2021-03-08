import 'package:flutter/material.dart';
import 'package:veno/veno.dart';
import 'app.dart';

void main() {
  runApp(
    Veno(
      singleton: true,
      child: App(),
    ),
  );
}
