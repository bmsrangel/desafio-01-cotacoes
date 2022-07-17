import 'dart:convert';

class ServiceCResponseModel {
  ServiceCResponseModel({
    required this.cid,
    required this.mensagem,
  });

  final String cid;
  final String mensagem;

  Map<String, dynamic> toMap() {
    return {
      'cid': cid,
      'mensagem': mensagem,
    };
  }

  factory ServiceCResponseModel.fromMap(Map<String, dynamic> map) {
    return ServiceCResponseModel(
      cid: map['cid'] ?? '',
      mensagem: map['mensagem'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ServiceCResponseModel.fromJson(String source) =>
      ServiceCResponseModel.fromMap(json.decode(source));
}
