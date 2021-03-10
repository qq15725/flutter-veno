import 'package:flutter/foundation.dart';
import '../veno.dart';
import '../veno_provider.dart';

/// 错误处理
///
class ErrorHandleProvider extends VenoProvider {
  @override
  Future<void> registerProvider(Veno app) async {
    if (app.onError != null) {
      FlutterError.onError = app.onError;
    }
  }
}