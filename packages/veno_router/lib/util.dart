part of 'veno_router.dart';

List<String> _patternToParts(String pattern) {
  List<String> parts = [];
  pattern.split('/').where((part) => part.isNotEmpty).forEach((part) {
    parts.add(part);
    if (part.startsWith('*')) {
      return;
    }
  });
  return parts;
}
