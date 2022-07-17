import 'package:dio/dio.dart';

import '../models/quotation_model.dart';

class ServiceAQuotationServiceImpl {
  ServiceAQuotationServiceImpl(this._client);

  final Dio _client;

  Future<QuotationModel> getQuotation(String currency) async {
    final response = await _client.get(
      '/servico-a/cotacao',
      queryParameters: {
        'moeda': 'USD',
      },
    );
    if (response.statusCode == 200) {
      return QuotationModel(
        currency: response.data['moeda'],
        price: response.data['cotacao'],
      );
    } else {
      throw Exception();
    }
  }
}
