class VenoContainer {
  Map<String, dynamic> _instances = {};

  T offsetGet<T>([key]) {
    if (key == null) {
      key = T.toString();
    }
    return _instances[key];
  }

  T offsetSet<T>(dynamic value, {dynamic key}) {
    if (key != null) {
      if (key is Type) {
        key = key.toString();
      }
    } else if (T != null) {
      key = T.toString();
    } else {
      return value;
    }
    _instances[key] = value;
    return value;
  }
}
