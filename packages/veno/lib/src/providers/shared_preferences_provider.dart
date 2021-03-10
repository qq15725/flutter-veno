import 'package:shared_preferences/shared_preferences.dart';
import '../veno.dart';
import '../veno_provider.dart';

/// [SharedPreferences]
///
class SharedPreferencesProvider extends VenoProvider {
  @override
  Future<void> registerProvider(Veno app) async {
    app.set<SharedPreferences>(await SharedPreferences.getInstance());
  }
}