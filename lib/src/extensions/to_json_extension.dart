import 'dart:convert';

extension ToJsonExtension on Map {
  String toJson() {
    return jsonEncode(this);
  }
}
