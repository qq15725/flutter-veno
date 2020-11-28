import 'package:veno_container/veno_container.dart';

class Veno extends VenoContainer {
  static Veno _singleton = Veno._internal();

  factory Veno() => _singleton;

  Veno._internal() {}

  static T get<T>([key]) => _singleton.offsetGet(key);

  static T set<T>(dynamic value, {dynamic key}) =>
      _singleton.offsetSet<T>(value, key: key);
}
