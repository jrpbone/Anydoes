import 'dart:convert';

abstract final class CanonicalJson {
  static String encode(Object? value) => jsonEncode(_normalize(value));

  static Object? _normalize(Object? value) {
    if (value == null || value is String || value is bool) return value;
    if (value is num) {
      if (value is double && !value.isFinite) {
        throw ArgumentError.value(value, 'value', 'Must be finite JSON');
      }
      return value;
    }
    if (value is List) {
      return [for (final item in value) _normalize(item)];
    }
    if (value is Map) {
      if (value.keys.any((key) => key is! String)) {
        throw ArgumentError.value(value, 'value', 'JSON keys must be strings');
      }
      final keys = value.keys.cast<String>().toList()..sort();
      return <String, Object?>{
        for (final key in keys) key: _normalize(value[key]),
      };
    }
    throw ArgumentError.value(value, 'value', 'Not a JSON value');
  }
}
