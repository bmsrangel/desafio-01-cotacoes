import 'dart:convert';

class CallbackRequestModel {
  CallbackRequestModel({
    required this.type,
    required this.factor,
    required this.value,
  });

  final String type;
  final num factor;
  final double value;

  Map<String, dynamic> toMap() {
    return {
      't': type,
      'f': factor,
      'v': value,
    };
  }

  factory CallbackRequestModel.fromMap(Map<String, dynamic> map) {
    return CallbackRequestModel(
      type: map['t'] ?? '',
      factor: map['f'] ?? 0,
      value: map['v']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory CallbackRequestModel.fromJson(String source) =>
      CallbackRequestModel.fromMap(json.decode(source));
}
