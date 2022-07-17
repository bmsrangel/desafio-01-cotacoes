import 'dart:convert';

class QuotationModel {
  QuotationModel({
    required this.currency,
    required this.price,
  });

  final String currency;
  final double price;

  Map<String, dynamic> toMap() {
    return {
      'currency': currency,
      'price': price,
    };
  }

  factory QuotationModel.fromMap(Map<String, dynamic> map) {
    return QuotationModel(
      currency: map['currency'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory QuotationModel.fromJson(String source) =>
      QuotationModel.fromMap(json.decode(source));
}
