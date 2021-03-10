import 'package:flutter/material.dart';
import 'veno.dart';

typedef VenoProviderRegister(Veno app);

typedef VenoProviderBoot(Veno app);

@immutable
class VenoProvider {
  const VenoProvider({this.register, this.boot});

  /// [Veno] setup 时调用
  ///
  final VenoProviderRegister register;

  /// [Veno] boot 时调用
  ///
  final VenoProviderBoot boot;

  Future<void> registerProvider(Veno app) async {
    if (register != null) {
      await register(app);
    }
  }

  Future<void> bootProvider(Veno app) async {
    if (boot != null) {
      await boot(app);
    }
  }
}
